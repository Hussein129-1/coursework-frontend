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
  <div id="app" class="app-shell">
    <div class="app-container">
      <!-- Top header bar with app title and cart toggle button -->
      <header class="app-header">
        <div class="app-header__copy">
          <h1 class="app-title">
            <i class="fas fa-graduation-cap"></i>
            After School Classes
          </h1>
          <p class="app-subtitle">
            Browse after-school lessons and reserve spots instantly.
          </p>
        </div>
        <button
          class="cart-toggle"
          :class="{ 'cart-toggle--active': showCart }"
          :disabled="!showCart && cartItems.length === 0"
          @click="toggleCart"
        >
          <i :class="['fas', showCart ? 'fa-arrow-left' : 'fa-shopping-cart']"></i>
          <span>{{ showCart ? 'Back to lessons' : `Cart (${cartItemCount})` }}</span>
        </button>
      </header>

      <main class="app-main">
        <!-- Status panel shown while lessons are loading -->
        <section v-if="isLoading" class="panel panel--status">
          <div class="panel__icon">
            <i class="fas fa-spinner fa-spin"></i>
          </div>
          <p class="panel__title">Loading lessons…</p>
          <p class="panel__subtitle">Hang tight while we fetch the latest availability.</p>
        </section>

        <!-- Error panel shown when there is a problem fetching lessons from the backend -->
        <section v-else-if="error" class="panel panel--status panel--error">
          <div class="panel__icon">
            <i class="fas fa-exclamation-triangle"></i>
          </div>
          <p class="panel__title">Something went wrong</p>
          <p class="panel__subtitle">{{ error }}</p>
          <button class="btn-primary panel__action" @click="fetchLessons">
            Try again
          </button>
        </section>

        <!-- Main content area when lessons are loaded successfully and there is no error -->
        <section v-else class="app-content">
          <!-- Success alert shown briefly after a successful booking -->
          <transition name="fade" mode="out-in">
            <div v-if="showSuccessMessage" key="success" class="alert alert--success">
              <i class="fas fa-check-circle"></i>
              <span>Your booking has been confirmed.</span>
              <button
                class="alert__dismiss"
                @click="showSuccessMessage = false"
                aria-label="Dismiss success message"
              >
                <i class="fas fa-times"></i>
              </button>
            </div>
          </transition>

          <!-- Show lessons list view when the cart is not currently open -->
          <div v-if="!showCart" class="lessons-view">
            <LessonList
              :lessons="displayedLessons"
              :sort-by="sortBy"
              :sort-order="sortOrder"
              :is-searching="isSearching"
              @add-to-cart="addToCart"
              @update-sort="updateSort"
              @search="handleSearch"
              @clear-search="clearSearch"
            />
          </div>

          <!-- Otherwise show the cart and checkout columns side by side -->
          <div v-else class="cart-view">
            <section class="cart-column">
              <ShoppingCart
                :cart-items="cartItems"
                @remove-from-cart="removeFromCart"
                @close-cart="toggleCart"
              />
            </section>
            <section class="checkout-column">
              <CheckoutForm
                v-if="cartItems.length > 0"
                :cart-items="cartItems"
                :is-submitting="isSubmittingOrder"
                @submit-order="submitOrder"
                ref="checkoutFormRef"
              />
              <!-- Empty state panel when there are no items in the cart -->
              <div v-else class="panel panel--status panel--empty">
                <div class="panel__icon">
                  <i class="fas fa-box-open"></i>
                </div>
                <p class="panel__title">Your cart is empty</p>
                <p class="panel__subtitle">Add lessons from the list to start checkout.</p>
                <button class="btn-primary panel__action" @click="toggleCart">
                  Browse lessons
                </button>
              </div>
            </section>
          </div>
        </section>
      </main>
    </div>
  </div>
</template>

<script setup>
// ========================================
// IMPORTS
// ========================================
import { ref, computed, onMounted } from 'vue';
import { API_ENDPOINTS, ASSET_ENDPOINTS } from './config.js';

// Import child components
import LessonList from './components/LessonList.vue';
import ShoppingCart from './components/ShoppingCart.vue';
import CheckoutForm from './components/CheckoutForm.vue';

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
const enhanceLesson = (lesson) => ({
  ...lesson,
  imageUrl: ASSET_ENDPOINTS.lessonImage(lesson.image)
});

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
    lessons.value = data.map(enhanceLesson);
    
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
    searchResults.value = data.map(enhanceLesson);
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
 * Handle search input from LessonList component
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
.app-shell {
  min-height: 100vh;
  display: flex;
  justify-content: center;
}

.app-container {
  width: 100%;
  max-width: 1080px;
  padding: var(--spacing-xl) var(--spacing-lg);
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xl);
}

.app-header {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: var(--spacing-md);
}

.app-header__copy {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.app-title {
  margin: 0;
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
  font-size: clamp(1.8rem, 3vw, 2.4rem);
  color: var(--text-primary);
}

.app-title i {
  color: var(--primary-color);
}

.app-subtitle {
  margin: 0;
  color: var(--text-secondary);
  font-size: 0.95rem;
}

.cart-toggle {
  display: inline-flex;
  align-items: center;
  gap: var(--spacing-sm);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-lg);
  background: var(--surface);
  padding: 0.65rem 1.2rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
}

.cart-toggle i {
  color: var(--primary-color);
}

.cart-toggle--active {
  background: var(--primary-color);
  color: #fff;
  border-color: transparent;
}

.cart-toggle--active i {
  color: #fff;
}

.cart-toggle:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.app-main {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xl);
}

.app-content {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-lg);
}

.lessons-view {
  display: flex;
}

.cart-view {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: var(--spacing-lg);
}

.cart-column,
.checkout-column {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-lg);
}

.panel {
  background: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(148, 163, 184, 0.25);
  border-radius: var(--radius-lg);
  padding: var(--spacing-xl);
  text-align: center;
  box-shadow: var(--shadow-sm);
  display: grid;
  gap: var(--spacing-sm);
  justify-items: center;
}

.panel__icon {
  font-size: 2rem;
  color: var(--primary-color);
}

.panel__title {
  margin: 0;
  font-weight: 600;
  color: var(--text-primary);
  font-size: 1.1rem;
}

.panel__subtitle {
  margin: 0;
  color: var(--text-secondary);
  font-size: 0.9rem;
}

.panel__action {
  margin-top: var(--spacing-sm);
}

.panel--error {
  border-color: rgba(239, 68, 68, 0.3);
}

.panel--status {
  min-height: 220px;
}

.panel--empty .panel__icon {
  color: var(--text-secondary);
}

.alert {
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
  padding: var(--spacing-md) var(--spacing-lg);
  border-radius: var(--radius-md);
  border: 1px solid transparent;
  font-weight: 600;
}

.alert--success {
  background: rgba(16, 185, 129, 0.12);
  border-color: rgba(16, 185, 129, 0.3);
  color: var(--success-color);
}

.alert__dismiss {
  margin-left: auto;
  border: none;
  background: transparent;
  color: inherit;
  cursor: pointer;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

@media (max-width: 768px) {
  .app-container {
    padding: var(--spacing-lg) var(--spacing-md);
  }

  .cart-toggle {
    width: 100%;
    justify-content: center;
  }

  .cart-view {
    grid-template-columns: 1fr;
  }
}
</style>
