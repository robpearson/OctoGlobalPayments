// Retrieve product API URL from environment variable or use default
const productApiUrl = 'http://product-api-service:3000/products'

console.log("Script is running");

// Function to fetch product data from the API
async function fetchProductData() {
    try {
        const response = await fetch(productApiUrl);
        if (!response.ok) {
            throw new Error('Failed to fetch products');
        }
        return response.json();
    } catch (error) {
        console.error('Error fetching products:', error);
        throw error;
    }
}

// Function to update the HTML table with product data
async function updateProductTable() {
    const productTableBody = document.querySelector('#product-table tbody');
    try {
        // Fetch product data from the API
        const products = await fetchProductData();
        // Clear existing table rows
        productTableBody.innerHTML = '';
        // Populate the table with product data
        products.forEach(product => {
            const row = `
        <tr>
          <td>${product.id}</td>
          <td>${product.name}</td>
          <td>${product.price}</td>
        </tr>
      `;
            productTableBody.innerHTML += row;
        });
    } catch (error) {
        // Display an error message if fetching data fails
        const errorMessage = document.createElement('div');
        errorMessage.textContent = 'Failed to fetch products. Please try again later.';
        productTableBody.appendChild(errorMessage);
    }
}

// Call the function to update the product table when the page loads
updateProductTable();