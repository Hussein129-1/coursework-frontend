<!--
  ========================================
  MAIN APPLICATION COMPONENT (App.vue)
  ========================================
  This is the root component of the After School Classes booking application
  It manages the overall application state and coordinates between child components
  
  KEY FEATURES:
  1. Fetches lessons from backend API
  2. Manages shopping cart state
  3. Handles lesson sorting
  4. Implements search functionality
  5. Processes checkout and order submission
  6. Updates lesson availability after orders
-->

<template>
  <!-- Main Application Container -->
  <div id="app">
    <div class="container">
      <!-- Application Header -->
      <header class="app-header">
        <h1>
          <i class="fas fa-graduation-cap"></i>
          After School Classes
        </h1>
        <p class="subtitle">Book your favorite classes and activities</p>
        
        <!-- Shopping Cart Button -->
        <!--
          :disabled - Button disabled when cart is empty
          @click - Toggle between lessons view and cart view
          :class - Apply different styles based on current view
        -->
        <button
          class="btn-primary cart-toggle-btn"
          :disabled="cartItems.length === 0 && !showCart"
          @click="toggleCart"
          :class="{ 'active': showCart }"
        >
          <i class="fas fa-shopping-cart"></i>
          {{ showCart ? 'View Lessons' : 'View Cart' }}
          <!-- Cart badge showing number of items -->
          <span v-if="cartItemCount > 0" class="cart-badge">{{ cartItemCount }}</span>
        </button>
      </header>

      <!-- Loading State -->
      <!--
        v-if - Conditionally render based on loading state
        Shows animated spinner while fetching data from backend
      -->
      <div v-if="isLoading" class="loading-state">
        <div class="loader-container">
          <div class="spinner-ring">
            <div></div>
            <div></div>
            <div></div>
            <div></div>
          </div>
          <i class="fas fa-graduation-cap loader-icon"></i>
        </div>
        <p class="loading-text">Loading lessons...</p>
        <div class="loading-dots">
          <span></span>
          <span></span>
          <span></span>
        </div>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="error-state">
        <i class="fas fa-exclamation-triangle"></i>
        <h3>Oops! Something went wrong</h3>
        <p>{{ error }}</p>
        <button class="btn-primary" @click="fetchLessons">
          <i class="fas fa-redo"></i>
          Try Again
        </button>
      </div>

      <!-- Main Content -->
      <div v-else>
        <!-- Success Message (after checkout) -->
        <!--
          v-if - Only show when order is successfully submitted
          Success message with auto-dismiss after 5 seconds
        -->
        <div v-if="showSuccessMessage" class="success-message">
          <i class="fas fa-check-circle"></i>
          <div>
            <strong>Order Confirmed!</strong>
            <p>Thank you for your booking. We'll contact you soon.</p>
          </div>
          <button @click="showSuccessMessage = false" class="close-btn">
            <i class="fas fa-times"></i>
          </button>
        </div>

        <!-- Lessons View -->
        <!--
          v-if - Show lessons when not viewing cart
        -->
        <div v-if="!showCart">
          <!-- Search Bar Component -->
          <SearchBar
            :is-searching="isSearching"
            @search="handleSearch"
            @clear-search="clearSearch"
          />
          
          <!-- Lessons List Component -->
          <LessonList
            :lessons="displayedLessons"
            :sort-by="sortBy"
            :sort-order="sortOrder"
            @add-to-cart="addToCart"
            @update-sort="updateSort"
          />
        </div>

        <!-- Cart View -->
        <!--
          v-else - Show cart when showCart is true
        -->
        <div v-else class="cart-view">
          <!-- Shopping Cart Component -->
          <ShoppingCart
            :cart-items="cartItems"
            @remove-from-cart="removeFromCart"
            @close-cart="toggleCart"
          />
          
          <!-- Checkout Form Component -->
          <!--
            v-if - Only show checkout form when cart has items
          -->
          <CheckoutForm
            v-if="cartItems.length > 0"
            :cart-items="cartItems"
            :is-submitting="isSubmittingOrder"
            @submit-order="submitOrder"
            ref="checkoutFormRef"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
// ========================================
// IMPORTS
// ========================================
import { ref, computed, onMounted } from 'vue';
import { API_ENDPOINTS } from './config.js';

// Import child components
import LessonList from './components/LessonList.vue';
import LessonCard from './components/LessonCard.vue';
import ShoppingCart from './components/ShoppingCart.vue';
import CheckoutForm from './components/CheckoutForm.vue';
import SearchBar from './components/SearchBar.vue';

// ========================================
// REACTIVE STATE
// ========================================
// ref() creates reactive variables that Vue tracks for changes

// Lessons data
const lessons = ref([]);              // Original lessons from database
const searchResults = ref([]);        // Filtered lessons from search
const isSearchActive = ref(false);    // Whether search is active

// Cart data
const cartItems = ref([]);            // Array of items in cart
const showCart = ref(false);          // Toggle between lessons and cart view

// Sorting state
const sortBy = ref('subject');        // Current sort attribute
const sortOrder = ref('asc');         // Current sort order (asc/desc)

// UI state
const isLoading = ref(false);         // Loading indicator
const isSearching = ref(false);       // Search in progress indicator
const isSubmittingOrder = ref(false); // Order submission indicator
const error = ref(null);              // Error message
const showSuccessMessage = ref(false); // Success message visibility

// Template ref for checkout form
const checkoutFormRef = ref(null);

// ========================================
// COMPUTED PROPERTIES
// ========================================
// Computed properties automatically recalculate when dependencies change

/**
 * Get lessons to display based on search state
 * If search is active, show search results
 * Otherwise, show all lessons
 */
const displayedLessons = computed(() => {
  return isSearchActive.value ? searchResults.value : lessons.value;
});

/**
 * Calculate total number of items in cart
 * Sums up quantities of all cart items
 */
const cartItemCount = computed(() => {
  return cartItems.value.reduce((total, item) => total + item.quantity, 0);
});

// ========================================
// LIFECYCLE HOOKS
// ========================================
// onMounted runs after the component is first rendered

/**
 * Fetch lessons when app loads
 */
onMounted(() => {
  fetchLessons();
});

// ========================================
// API FUNCTIONS (Using Fetch)
// ========================================
// These functions communicate with the Express.js backend

/**
 * Fetch all lessons from the backend API
 * Uses native fetch() as required by coursework
 * Implements Promise-based async/await pattern
 */
const fetchLessons = async () => {
  isLoading.value = true;
  error.value = null;
  
  try {
    // Make GET request to backend
    // fetch() returns a Promise
    const response = await fetch(API_ENDPOINTS.lessons);
    
    // Check if request was successful
    if (!response.ok) {
      throw new Error(`HTTP error! Status: ${response.status}`);
    }
    
    // Parse JSON response
    const data = await response.json();
    
    // Update reactive state with fetched data
    lessons.value = data;
    
    console.log('✅ Successfully fetched lessons:', data.length);
  } catch (err) {
    // Handle errors
    console.error('❌ Error fetching lessons:', err);
    error.value = 'Failed to load lessons. Please check if the backend server is running.';
  } finally {
    // Always runs, regardless of success or error
    isLoading.value = false;
  }
};

/**
 * Search lessons via backend API
 * Implements the challenge component (Approach 2)
 * @param {String} query - Search query string
 */
const searchLessonsAPI = async (query) => {
  isSearching.value = true;
  
  try {
    // Make GET request with query parameter
    // Use URLSearchParams to properly encode query string
    const url = `${API_ENDPOINTS.search}?q=${encodeURIComponent(query)}`;
    const response = await fetch(url);
    
    if (!response.ok) {
      throw new Error(`Search failed! Status: ${response.status}`);
    }
    
    const data = await response.json();
    
    // Update search results
    searchResults.value = data;
    isSearchActive.value = true;
    
    console.log(`🔍 Search results for "${query}":`, data.length);
  } catch (err) {
    console.error('❌ Error searching lessons:', err);
    // Fall back to showing all lessons on error
    searchResults.value = lessons.value;
  } finally {
    isSearching.value = false;
  }
};

/**
 * Submit order to backend API
 * Creates order in database via POST request
 * @param {Object} customerInfo - Customer name and phone
 */
const submitOrderAPI = async (customerInfo) => {
  isSubmittingOrder.value = true;
  
  try {
    // Prepare order data
    // Extract lesson IDs and quantities from cart
    const lessonIds = cartItems.value.map(item => item.lesson._id);
    const spaces = cartItems.value.reduce((acc, item) => {
      acc[item.lesson._id] = item.quantity;
      return acc;
    }, {});
    
    const orderData = {
      name: customerInfo.name,
      phone: customerInfo.phone,
      lessonIds: lessonIds,
      spaces: spaces
    };
    
    // Make POST request to create order
    const response = await fetch(API_ENDPOINTS.order, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(orderData)
    });
    
    if (!response.ok) {
      throw new Error(`Order submission failed! Status: ${response.status}`);
    }
    
    const data = await response.json();
    console.log('✅ Order created:', data);
    
    // Update lesson spaces in backend for each cart item
    await updateLessonSpaces();
    
    return data;
  } catch (err) {
    console.error('❌ Error submitting order:', err);
    throw err;
  } finally {
    isSubmittingOrder.value = false;
  }
};

/**
 * Update lesson spaces in backend after order
 * Makes PUT request for each lesson in cart
 */
const updateLessonSpaces = async () => {
  try {
    // Create array of update promises
    const updatePromises = cartItems.value.map(async (item) => {
      const lessonId = item.lesson._id;
      const newSpaces = item.lesson.spaces; // Already updated in frontend
      
      // Make PUT request to update spaces
      const response = await fetch(API_ENDPOINTS.updateLesson(lessonId), {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ spaces: newSpaces })
      });
      
      if (!response.ok) {
        throw new Error(`Failed to update lesson ${lessonId}`);
      }
      
      return response.json();
    });
    
    // Wait for all updates to complete
    // Promise.all() waits for all promises to resolve
    await Promise.all(updatePromises);
    
    console.log('✅ All lesson spaces updated');
  } catch (err) {
    console.error('❌ Error updating lesson spaces:', err);
    throw err;
  }
};

// ========================================
// EVENT HANDLERS
// ========================================
// Functions that respond to user interactions

/**
 * Handle search input from SearchBar component
 * Implements "search as you type" functionality
 * @param {String} query - Search query from user
 */
const handleSearch = (query) => {
  if (query === '') {
    // If query is empty, show all lessons
    clearSearch();
    return;
  }
  
  // Trigger backend search
  searchLessonsAPI(query);
};

/**
 * Clear search and show all lessons
 */
const clearSearch = () => {
  searchResults.value = [];
  isSearchActive.value = false;
};

/**
 * Add lesson to shopping cart
 * @param {Object} lesson - Lesson object to add
 */
const addToCart = (lesson) => {
  // Check if lesson has available spaces
  if (lesson.spaces <= 0) {
    alert('Sorry, this lesson is fully booked!');
    return;
  }
  
  // Check if lesson is already in cart
  const existingItem = cartItems.value.find(
    item => item.lesson._id === lesson._id
  );
  
  if (existingItem) {
    // Increase quantity if already in cart
    existingItem.quantity++;
  } else {
    // Add new item to cart
    cartItems.value.push({
      lesson: lesson,
      quantity: 1
    });
  }
  
  // Decrease available spaces in the lesson
  // Find the lesson in the main lessons array
  const lessonInList = lessons.value.find(l => l._id === lesson._id);
  if (lessonInList) {
    lessonInList.spaces--;
  }
  
  // Also update in search results if search is active
  if (isSearchActive.value) {
    const lessonInSearch = searchResults.value.find(l => l._id === lesson._id);
    if (lessonInSearch) {
      lessonInSearch.spaces--;
    }
  }
  
  console.log(`📦 Added ${lesson.subject} to cart`);
};

/**
 * Remove lesson from shopping cart
 * @param {String} lessonId - ID of lesson to remove
 */
const removeFromCart = (lessonId) => {
  // Find item in cart
  const itemIndex = cartItems.value.findIndex(
    item => item.lesson._id === lessonId
  );
  
  if (itemIndex === -1) return;
  
  const item = cartItems.value[itemIndex];
  
  // Restore spaces to the lesson
  const lessonInList = lessons.value.find(l => l._id === lessonId);
  if (lessonInList) {
    lessonInList.spaces += item.quantity;
  }
  
  // Also update in search results if search is active
  if (isSearchActive.value) {
    const lessonInSearch = searchResults.value.find(l => l._id === lessonId);
    if (lessonInSearch) {
      lessonInSearch.spaces += item.quantity;
    }
  }
  
  // Remove item from cart
  cartItems.value.splice(itemIndex, 1);
  
  console.log(`🗑️ Removed ${item.lesson.subject} from cart`);
};

/**
 * Toggle between lessons view and cart view
 */
const toggleCart = () => {
  showCart.value = !showCart.value;
};

/**
 * Update sorting preferences
 * @param {Object} sortOptions - Object with sortBy and sortOrder
 */
const updateSort = (sortOptions) => {
  sortBy.value = sortOptions.sortBy;
  sortOrder.value = sortOptions.sortOrder;
};

/**
 * Submit order (called from CheckoutForm component)
 * @param {Object} customerInfo - Customer name and phone
 */
const submitOrder = async (customerInfo) => {
  try {
    // Submit order to backend
    await submitOrderAPI(customerInfo);
    
    // Clear cart after successful order
    cartItems.value = [];
    
    // Show success message
    showSuccessMessage.value = true;
    
    // Auto-hide success message after 5 seconds
    setTimeout(() => {
      showSuccessMessage.value = false;
    }, 5000);
    
    // Reset checkout form
    if (checkoutFormRef.value) {
      checkoutFormRef.value.resetForm();
    }
    
    // Switch back to lessons view
    showCart.value = false;
    
    // Refresh lessons from backend to get updated data
    await fetchLessons();
    
  } catch (err) {
    alert('Failed to submit order. Please try again.');
  }
};
</script>

<style scoped>
/* ========================================
   COMPONENT STYLES
   ======================================== */

/* Application Header */
.app-header {
  text-align: center;
  margin-bottom: var(--spacing-xl);
  padding-bottom: var(--spacing-xl);
  border-bottom: 2px solid var(--border-color);
  position: relative;
}

.app-header h1 {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: var(--spacing-md);
  margin-bottom: var(--spacing-sm);
}

.app-header h1 i {
  color: var(--primary-color);
}

.subtitle {
  color: var(--text-secondary);
  font-size: 1.1rem;
  margin-bottom: var(--spacing-lg);
}

/* Cart Toggle Button */
.cart-toggle-btn {
  position: relative;
  padding: 0.75rem 1.5rem;
  font-size: 1rem;
}

.cart-toggle-btn.active {
  background-color: var(--success-color);
}

.cart-toggle-btn.active:hover {
  background-color: var(--success-color);
  opacity: 0.9;
}

/* Cart Badge */
.cart-badge {
  position: absolute;
  top: -8px;
  right: -8px;
  background-color: var(--danger-color);
  color: white;
  border-radius: 50%;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.75rem;
  font-weight: 700;
  border: 2px solid var(--surface);
}

/* Loading State */
.loading-state {
  text-align: center;
  padding: var(--spacing-xl) * 2;
  background: var(--surface);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-lg);
  min-height: 400px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.loader-container {
  position: relative;
  width: 120px;
  height: 120px;
  margin-bottom: var(--spacing-xl);
}

/* Animated spinner ring */
.spinner-ring {
  position: absolute;
  width: 100%;
  height: 100%;
}

.spinner-ring div {
  position: absolute;
  width: 100%;
  height: 100%;
  border: 4px solid transparent;
  border-top-color: var(--primary-color);
  border-radius: 50%;
  animation: spin 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite;
}

.spinner-ring div:nth-child(1) {
  animation-delay: -0.45s;
  border-top-color: var(--primary-color);
}

.spinner-ring div:nth-child(2) {
  animation-delay: -0.3s;
  border-top-color: var(--primary-hover);
}

.spinner-ring div:nth-child(3) {
  animation-delay: -0.15s;
  border-top-color: var(--success-color);
}

.spinner-ring div:nth-child(4) {
  border-top-color: rgba(79, 70, 229, 0.3);
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

.loader-icon {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  font-size: 2.5rem;
  color: var(--primary-color);
  animation: pulse 1.5s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
    transform: translate(-50%, -50%) scale(1);
  }
  50% {
    opacity: 0.5;
    transform: translate(-50%, -50%) scale(0.9);
  }
}

.loading-text {
  font-size: 1.25rem;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: var(--spacing-sm);
}

.loading-dots {
  display: flex;
  gap: var(--spacing-xs);
}

.loading-dots span {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background-color: var(--primary-color);
  animation: bounce 1.4s infinite ease-in-out;
}

.loading-dots span:nth-child(1) {
  animation-delay: -0.32s;
}

.loading-dots span:nth-child(2) {
  animation-delay: -0.16s;
}

@keyframes bounce {
  0%, 80%, 100% {
    transform: scale(0);
    opacity: 0.5;
  }
  40% {
    transform: scale(1);
    opacity: 1;
  }
}

/* Error State */
.error-state {
  text-align: center;
  padding: var(--spacing-xl);
  background: var(--surface);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
  border: 2px solid var(--danger-color);
}

.error-state i {
  font-size: 3rem;
  color: var(--danger-color);
  margin-bottom: var(--spacing-md);
}

.error-state h3 {
  color: var(--text-primary);
  margin-bottom: var(--spacing-sm);
}

.error-state p {
  color: var(--text-secondary);
  margin-bottom: var(--spacing-lg);
}

/* Success Message */
.success-message {
  display: flex;
  align-items: center;
  gap: var(--spacing-md);
  padding: var(--spacing-lg);
  background: rgba(16, 185, 129, 0.1);
  border: 2px solid var(--success-color);
  border-radius: var(--radius-lg);
  margin-bottom: var(--spacing-xl);
  animation: slideDown 0.3s ease;
}

@keyframes slideDown {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.success-message i {
  font-size: 2rem;
  color: var(--success-color);
}

.success-message strong {
  display: block;
  color: var(--success-color);
  font-size: 1.1rem;
  margin-bottom: var(--spacing-xs);
}

.success-message p {
  margin: 0;
  color: var(--text-secondary);
}

.close-btn {
  margin-left: auto;
  background: transparent;
  border: none;
  color: var(--text-secondary);
  cursor: pointer;
  padding: var(--spacing-sm);
  border-radius: var(--radius-sm);
  transition: all 0.2s ease;
}

.close-btn:hover {
  background: rgba(0, 0, 0, 0.05);
  color: var(--danger-color);
}

/* Cart View */
.cart-view {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xl);
}

/* Responsive Design */
@media (max-width: 768px) {
  .app-header h1 {
    font-size: 2rem;
    flex-direction: column;
  }
  
  .subtitle {
    font-size: 1rem;
  }
  
  .success-message {
    flex-direction: column;
    text-align: center;
  }
  
  .close-btn {
    margin-left: 0;
  }
}
</style>
