require('dotenv').config();  // Load environment variables
const express = require('express');  // Import express for API routes
const db = require('./db_crowdfunding_connect');  // Import the MySQL connection
const app = express();  // Initialize the express app
const cors = require('cors');
app.use(cors());

app.use(express.json());  // Middleware to parse incoming JSON requests

// Define the port from environment variables or use 3060 as default
const port = process.env.PORT || 3060;

// Start the server on the defined port
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

// serves static files from public folder
app.use(express.static('public'));

// Default route to handle base URL ("/")
app.get('/', (req, res) => {
  res.send('Welcome to the Crowdfunding API');  // Basic welcome message for root URL
});

// 1. GET all active fundraisers with their categories and images
app.get('/api/fundraisers', (req, res) => {
  const query = `
    SELECT FUNDRAISER.FUNDRAISER_ID, ORGANIZER, CAPTION, TARGET_FUNDING, CURRENT_FUNDING, CITY, ACTIVE, CATEGORY.NAME AS CATEGORY_NAME, FUNDRAISER.image
    FROM FUNDRAISER
    JOIN CATEGORY ON FUNDRAISER.CATEGORY_ID = CATEGORY.CATEGORY_ID
    WHERE ACTIVE = true;
  `;
  
  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});

// 2. GET all categories
app.get('/api/categories', (req, res) => {
  const query = 'SELECT * FROM CATEGORY';
  
  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});

// 3. GET fundraisers by search criteria with images included
app.get('/api/search', (req, res) => {
  const { organizer, city, category_id } = req.query;

  let query = `
    SELECT FUNDRAISER.FUNDRAISER_ID, ORGANIZER, CAPTION, TARGET_FUNDING, CURRENT_FUNDING, CITY, ACTIVE, CATEGORY.NAME AS CATEGORY_NAME, FUNDRAISER.image
    FROM FUNDRAISER
    JOIN CATEGORY ON FUNDRAISER.CATEGORY_ID = CATEGORY.CATEGORY_ID
    WHERE ACTIVE = true
  `;

  let queryParams = [];

  if (organizer) {
    query += ' AND ORGANIZER LIKE ?';
    queryParams.push(`%${organizer}%`);
  }
  if (city) {
    query += ' AND CITY LIKE ?';
    queryParams.push(`%${city}%`);
  }
  if (category_id) {
    query += ' AND CATEGORY.CATEGORY_ID = ?';
    queryParams.push(category_id);
  }

  db.query(query, queryParams, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});

// 4. GET fundraiser details by ID (with rewards)
app.get('/api/fundraiser/:id', (req, res) => {
  const fundraiserId = req.params.id;

  // Query to get fundraiser details
  const fundraiserQuery = `
    SELECT FUNDRAISER.FUNDRAISER_ID, ORGANIZER, CAPTION, TARGET_FUNDING, CURRENT_FUNDING, CITY, ACTIVE, CATEGORY.NAME AS CATEGORY_NAME, FUNDRAISER.image
    FROM FUNDRAISER
    JOIN CATEGORY ON FUNDRAISER.CATEGORY_ID = CATEGORY.CATEGORY_ID
    WHERE FUNDRAISER.FUNDRAISER_ID = ?;
  `;

  // Query to get rewards associated with the fundraiser
  const rewardsQuery = `
    SELECT PLEDGE_AMOUNT, REWARD_DESCRIPTION
    FROM REWARDS
    WHERE PROJECT_ID = ?;
  `;

  // Execute both queries
  db.query(fundraiserQuery, [fundraiserId], (err, fundraiserResults) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }

    if (fundraiserResults.length === 0) {
      return res.status(404).json({ error: 'Fundraiser not found' });
    }

    // Fetch rewards only if the fundraiser is found
    db.query(rewardsQuery, [fundraiserId], (rewardErr, rewardResults) => {
      if (rewardErr) {
        return res.status(500).json({ error: rewardErr.message });
      }

      // Return fundraiser details along with rewards
      const fundraiser = fundraiserResults[0];
      fundraiser.rewards = rewardResults; // Attach rewards to fundraiser object

      res.json(fundraiser); // Send the fundraiser details and rewards in the response
    });
  });
});

// Improved APIs created for Part 2 in Assessment 3

// 1. GET fundraiser details (with donations)
app.get('/api/fundraiser/:id/donations', (req, res) => {
  const fundraiserId = req.params.id;
  const query = `
    SELECT FUNDRAISER.FUNDRAISER_ID, ORGANIZER, CAPTION, TARGET_FUNDING, CURRENT_FUNDING, CITY, ACTIVE, CATEGORY.NAME AS CATEGORY_NAME, FUNDRAISER.image,
           DONATION.DATE, DONATION.AMOUNT, DONATION.GIVER
    FROM FUNDRAISER
    JOIN CATEGORY ON FUNDRAISER.CATEGORY_ID = CATEGORY.CATEGORY_ID
    LEFT JOIN DONATION ON FUNDRAISER.FUNDRAISER_ID = DONATION.FUNDRAISER_ID
    WHERE FUNDRAISER.FUNDRAISER_ID = ?;
  `;
  
  db.query(query, [fundraiserId], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (results.length === 0) {
      return res.status(404).json({ error: 'Fundraiser not found' });
    }
    res.json(results);
  });
});

// 2. POST a new donation to a fundraiser
app.post('/api/fundraiser/:id/donation', (req, res) => {
  const fundraiserId = req.params.id;
  const { date, amount, giver } = req.body;
  const query = `
    INSERT INTO DONATION (DATE, AMOUNT, GIVER, FUNDRAISER_ID) 
    VALUES (?, ?, ?, ?);
  `;
  
  db.query(query, [date, amount, giver, fundraiserId], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.status(201).json({ message: 'Donation added successfully', donation_id: result.insertId });
  });
});

// 3. POST to create a new fundraiser
app.post('/api/fundraiser', (req, res) => {
  const { organizer, caption, target_funding, city, category_id, image } = req.body;
  const query = `
    INSERT INTO FUNDRAISER (ORGANIZER, CAPTION, TARGET_FUNDING, CURRENT_FUNDING, CITY, ACTIVE, CATEGORY_ID, image)
    VALUES (?, ?, ?, 0, ?, true, ?, ?);
  `;
  
  db.query(query, [organizer, caption, target_funding, city, category_id, image], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.status(201).json({ message: 'Fundraiser created successfully', fundraiser_id: result.insertId });
  });
});

// 4. PUT to update an existing fundraiser
app.put('/api/fundraiser/:id', (req, res) => {
  const fundraiserId = req.params.id;
  const { organizer, caption, target_funding, city, category_id, image } = req.body;
  const query = `
    UPDATE FUNDRAISER 
    SET ORGANIZER = ?, CAPTION = ?, TARGET_FUNDING = ?, CITY = ?, CATEGORY_ID = ?, image = ?
    WHERE FUNDRAISER_ID = ?;
  `;
  
  db.query(query, [organizer, caption, target_funding, city, category_id, image, fundraiserId], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Fundraiser not found' });
    }
    res.json({ message: 'Fundraiser updated successfully' });
  });
});

// 5. DELETE a fundraiser (only if there are no donations)
app.delete('/api/fundraiser/:id', (req, res) => {
  const fundraiserId = req.params.id;

  // Check if fundraiser has donations
  const checkQuery = `
    SELECT COUNT(*) AS donationCount FROM DONATION WHERE FUNDRAISER_ID = ?;
  `;
  
  db.query(checkQuery, [fundraiserId], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    
    if (result[0].donationCount > 0) {
      return res.status(400).json({ error: 'Cannot delete fundraiser with donations' });
    }
    
    // Proceed with deletion if no donations
    const deleteQuery = `
      DELETE FROM FUNDRAISER WHERE FUNDRAISER_ID = ?;
    `;
    
    db.query(deleteQuery, [fundraiserId], (deleteErr) => {
      if (deleteErr) {
        return res.status(500).json({ error: deleteErr.message });
      }
      res.json({ message: 'Fundraiser deleted successfully' });
    });
  });
});

// Catch-all route for undefined paths
app.use((req, res) => {
  res.status(404).send('404: Page not found');
});