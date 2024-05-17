var fs = require('fs');
const express = require('express');
const mysql = require('mysql2');

const app = express();
const PORT = process.env.PORT || 3000;

// Retrieve MySQL credentials from environment variables
const mysqlHost = process.env.MYSQL_HOST || 'localhost';
const mysqlUser = process.env.MYSQL_USER || 'root';
const mysqlPassword = process.env.MYSQL_PASSWORD || 'Mypassword01';
const mysqlDatabase = process.env.MYSQL_DATABASE || 'octokon';

console.log("Starting MySQL Connection")

// Create MySQL connection
// const serverCa = [fs.readFileSync("/var/DigiCertGlobalRootCA.crt.pem", "utf8")];


// const connection = mysql.createConnection({
//     host: mysqlHost,
//     user: mysqlUser,
//     password: mysqlPassword,
//     database: mysqlDatabase,
//     ssl: {
//         rejectUnauthorized: false,
//         ca: serverCa
//     }
// });

// const connection = mysql.createConnection({
//     host: mysqlHost,
//     user: mysqlUser,
//     password: mysqlPassword,
//     database: mysqlDatabase
// });


// Define a route to fetch products
// app.get('/products', (req, res) => {
//     connection.query('SELECT * FROM product', (error, results) => {
//         if (error) {
//             res.status(500).json({ error: 'Error fetching products' });
//         } else {
//             res.json(results);
//         }
//     });
// });


// Start the API server
app.listen(PORT, () => {
    console.log(`API server is running on port ${PORT}`);
});