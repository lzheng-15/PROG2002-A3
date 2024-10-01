const express = require('express');  // Import express for API routes
const connection = require('./db_crowdfunding_connect'); // Database connection for querying

const app = express();  // Initialize the express app
app.use(express.json());  // Middleware to parse incoming JSON requests

// 1. GET method to retrieve all active fundraisers including the category
// This will be used to display data on the Home page
app.get('/api/fundraisers', (req, res) => {
  const query = `
    SELECT FUNDRAISER.FUNDRAISER_ID, ORGANIZER, CAPTION, TARGET_FUNDING, CURRENT_FUNDING, CITY, ACTIVE, CATEGORY.NAME AS CATEGORY_NAME
    FROM FUNDRAISER
    JOIN CATEGORY ON FUNDRAISER.CATEGORY_ID = CATEGORY.CATEGORY_ID
    WHERE ACTIVE = 1;  -- Only active fundraisers are selected
  `;

  // Query the database for active fundraisers
  connection.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);  // Send back the results as a JSON response
  });
});

// 2. GET method to retrieve all categories from the database
// This will be used to populate categories in the Search fundraisers page
app.get('/api/categories', (req, res) => {
  const query = 'SELECT * FROM CATEGORY';  // SQL query to select all categories

  // Query the database for all categories
  connection.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);  // Send back the results as a JSON response
  });
});

// 3. GET method to retrieve active fundraisers including category based on criteria
// This will be used to retrieve data in the Search fundraisers page (filtered by criteria)
app.get('/api/search', (req, res) => {
  const { organizer, city, category_id } = req.query;  // Extract search criteria from query params

  let query = `
    SELECT FUNDRAISER.FUNDRAISER_ID, ORGANIZER, CAPTION, TARGET_FUNDING, CURRENT_FUNDING, CITY, ACTIVE, CATEGORY.NAME AS CATEGORY_NAME
    FROM FUNDRAISER
    JOIN CATEGORY ON FUNDRAISER.CATEGORY_ID = CATEGORY.CATEGORY_ID
    WHERE ACTIVE = 1
  `;  // Base query to select active fundraisers

  let queryParams = [];  // To store values for query placeholders

  // Add filters dynamically based on query parameters
  if (organizer) {
    query += ' AND ORGANIZER LIKE ?';  // Filter by organizer
    queryParams.push(`%${organizer}%`);  // Add value to queryParams
  }
  if (city) {
    query += ' AND CITY LIKE ?';  // Filter by city
    queryParams.push(`%${city}%`);  // Add value to queryParams
  }
  if (category_id) {
    query += ' AND CATEGORY.CATEGORY_ID = ?';  // Filter by category_id
    queryParams.push(category_id);  // Add value to queryParams
  }

  // Query the database based on the constructed query and parameters
  connection.query(query, queryParams, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);  // Send back the results as a JSON response
  });
});

// 4. GET method to retrieve the details of a fundraiser by its ID
// This will be used to display detailed information about a specific fundraiser on the Fundraiser page
app.get('/api/fundraiser/:id', (req, res) => {
  const fundraiserId = req.params.id;  // Extract the ID from the URL parameters

  const query = `
    SELECT FUNDRAISER.FUNDRAISER_ID, ORGANIZER, CAPTION, TARGET_FUNDING, CURRENT_FUNDING, CITY, ACTIVE, CATEGORY.NAME AS CATEGORY_NAME
    FROM FUNDRAISER
    JOIN CATEGORY ON FUNDRAISER.CATEGORY_ID = CATEGORY.CATEGORY_ID
    WHERE FUNDRAISER.FUNDRAISER_ID = ?;
  `;  // SQL query to select fundraiser details by ID

  // Query the database for a specific fundraiser by its ID
  connection.query(query, [fundraiserId], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (results.length === 0) {
      return res.status(404).json({ error: 'Fundraiser not found' });
    }
    res.json(results[0]);  // Send back the fundraiser details as a JSON response
  });
});

// Start the server and listen on a specified port (or default to port 3000)
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);  // Log that the server is up and running
});
