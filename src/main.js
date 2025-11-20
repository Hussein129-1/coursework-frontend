// ========================================
// VUE APPLICATION ENTRY FILE (main.js)
// ========================================
// This file is the starting point of the frontend application.
// It creates the Vue app instance and mounts it to the DOM.

import { createApp } from 'vue'
// Import the global stylesheet so all components share the same base styles
import './style.css'
// Import the root Vue component that contains the whole app UI and logic
import App from './App.vue'

// Create a new Vue application using the App component as the root
// Then mount it to the <div id="app"> element in index.html
createApp(App).mount('#app')
