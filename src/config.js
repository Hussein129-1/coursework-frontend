// ========================================
// APPLICATION CONFIGURATION
// ========================================
// This file contains all configuration settings for the frontend application
// Keeping configuration in one place makes it easy to update when deploying

// IMPORTANT: Update this URL when you deploy your backend to AWS or Render.com
// Local development: 'http://localhost:3000'
// Production: 'https://your-backend-url.com'
export const API_BASE_URL = 'http://localhost:3000';

// API Endpoints - These match the routes in your Express.js backend
export const API_ENDPOINTS = {
    // GET all lessons from the database
    lessons: `${API_BASE_URL}/lessons`,
    
    // GET search results (with query parameter ?q=searchterm)
    search: `${API_BASE_URL}/search`,
    
    // POST new order to the database
    order: `${API_BASE_URL}/order`,
    
    // PUT update lesson spaces (replace :id with actual lesson ID)
    updateLesson: (lessonId) => `${API_BASE_URL}/lessons/${lessonId}`
};
