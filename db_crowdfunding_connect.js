// db_crowdfunding_connect.js
const mysql = require('mysql');

const connection = mysql.createConnection({
    host: 'localhost',        
    user: 'root',             
    password: 'Stumar2024!',   
    database: 'smarle14_crowdfunding_db'
});

// Connect to the database
connection.connect((err) => {
    if (err) {
        console.error('Error connecting to the database:', err.stack);
        return;
    }
    console.log('Connected to the database');
});

module.exports = connection;
