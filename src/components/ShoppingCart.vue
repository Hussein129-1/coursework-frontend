<!--
  ========================================
  SHOPPING CART COMPONENT
  ========================================
  This component displays the shopping cart with all added lessons
  Users can review items and remove them if needed
  
  PROPS:
  - cartItems: Array of objects, each containing lesson details and quantity
  
  EMITS:
  - remove-from-cart: When user removes an item from cart
  - close-cart: When user wants to return to lessons page
-->

<template>
  <div class="shopping-cart">
    <!-- Cart Header -->
    <div class="cart-header">
      <h2>
        <i class="fas fa-shopping-cart"></i>
        Your Shopping Cart
      </h2>
      <button class="btn-primary" @click="closeCart">
        <i class="fas fa-arrow-left"></i>
        Continue Shopping
      </button>
    </div>
    
    <!-- Cart Content -->
    <div class="cart-content">
      <!-- Show cart items if cart is not empty -->
      <div v-if="cartItems.length > 0" class="cart-items">
        <!--
          v-for: Loop through each item in the cart
          :key: Unique identifier for efficient Vue updates
        -->
        <div
          v-for="item in cartItems"
          :key="item.lesson._id"
          class="cart-item"
        >
          <!-- Item Icon -->
          <div class="item-icon">
            <i :class="['fas', item.lesson.icon]"></i>
          </div>
          
          <!-- Item Details -->
          <div class="item-details">
            <h3>{{ item.lesson.subject }}</h3>
            <p class="item-location">
              <i class="fas fa-map-marker-alt"></i>
              {{ item.lesson.location }}
            </p>
            <p class="item-quantity">
              Quantity: <strong>{{ item.quantity }}</strong>
            </p>
          </div>
          
          <!-- Item Price -->
          <div class="item-price">
            <div class="price-per-unit">
              £{{ item.lesson.price }} each
            </div>
            <div class="price-total">
              £{{ (item.lesson.price * item.quantity).toFixed(2) }}
            </div>
          </div>
          
          <!-- Remove Button -->
          <!--
            @click: Event listener (v-on directive)
            Calls removeItem method when button is clicked
          -->
          <button
            class="btn-danger remove-btn"
            @click="removeItem(item.lesson._id)"
            :aria-label="`Remove ${item.lesson.subject} from cart`"
          >
            <i class="fas fa-trash"></i>
            Remove
          </button>
        </div>
      </div>
      
      <!-- Empty Cart State -->
      <!--
        v-else: Shows when v-if condition is false (cart is empty)
      -->
      <div v-else class="empty-cart">
        <i class="fas fa-shopping-cart"></i>
        <h3>Your cart is empty</h3>
        <p>Add some lessons to get started</p>
        <button class="btn-primary" @click="closeCart">
          Browse Lessons
        </button>
      </div>
    </div>
    
    <!-- Cart Summary -->
    <!--
      v-if: Only show summary when there are items in cart
    -->
    <div v-if="cartItems.length > 0" class="cart-summary">
      <div class="summary-row">
        <span>Total Items:</span>
        <strong>{{ totalQuantity }}</strong>
      </div>
      <div class="summary-row total">
        <span>Total Price:</span>
        <strong>£{{ totalPrice.toFixed(2) }}</strong>
      </div>
    </div>
  </div>
</template>

<script setup>
// ========================================
// IMPORTS
// ========================================
import { computed } from 'vue';

// ========================================
// PROPS (Data received from parent)
// ========================================
const props = defineProps({
  cartItems: {
    type: Array,
    required: true,
    default: () => []
    // Expected structure:
    // [
    //   {
    //     lesson: { _id, subject, location, price, icon, ... },
    //     quantity: Number
    //   }
    // ]
  }
});

// ========================================
// EMITS (Events sent to parent)
// ========================================
const emit = defineEmits(['remove-from-cart', 'close-cart']);

// ========================================
// COMPUTED PROPERTIES
// ========================================
// Computed properties automatically recalculate when dependencies change
// They are cached for performance

/**
 * Calculate total quantity of items in cart
 * Sums up the quantity of all items
 */
const totalQuantity = computed(() => {
  // reduce() iterates through array and accumulates a single value
  // sum: accumulator (running total)
  // item: current item in the array
  // 0: initial value for sum
  return props.cartItems.reduce((sum, item) => sum + item.quantity, 0);
});

/**
 * Calculate total price of all items in cart
 * Multiplies each item's price by quantity and sums them up
 */
const totalPrice = computed(() => {
  return props.cartItems.reduce((sum, item) => {
    return sum + (item.lesson.price * item.quantity);
  }, 0);
});

// ========================================
// METHODS (Functions)
// ========================================

/**
 * Remove an item from the cart
 * @param {String} lessonId - The ID of the lesson to remove
 */
const removeItem = (lessonId) => {
  // Emit event to parent component with the lesson ID
  // Parent will handle the actual removal from cart data
  emit('remove-from-cart', lessonId);
};

/**
 * Close cart and return to lessons view
 * Emits event to parent component to switch views
 */
const closeCart = () => {
  emit('close-cart');
};
</script>

<style scoped>
/* ========================================
   COMPONENT STYLES
   ======================================== */

.shopping-cart {
  width: 100%;
  max-width: 900px;
  margin: 0 auto;
}

/* Cart Header */
.cart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--spacing-xl);
  flex-wrap: wrap;
  gap: var(--spacing-md);
}

.cart-header h2 {
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
  margin: 0;
}

.cart-header h2 i {
  color: var(--primary-color);
}

/* Cart Content */
.cart-content {
  background: var(--surface);
  border-radius: var(--radius-lg);
  padding: var(--spacing-lg);
  box-shadow: var(--shadow-sm);
  margin-bottom: var(--spacing-lg);
}

/* Cart Items Container */
.cart-items {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-md);
}

/* Individual Cart Item */
.cart-item {
  display: flex;
  align-items: center;
  gap: var(--spacing-md);
  padding: var(--spacing-md);
  background: var(--background);
  border-radius: var(--radius-md);
  border: 1px solid var(--border-color);
  transition: all 0.2s ease;
}

.cart-item:hover {
  border-color: var(--primary-color);
  box-shadow: var(--shadow-sm);
}

/* Item Icon */
.item-icon {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--primary-color), var(--primary-hover));
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 1.25rem;
  flex-shrink: 0;
}

/* Item Details */
.item-details {
  flex: 1;
  min-width: 0; /* Allows text to truncate if needed */
}

.item-details h3 {
  font-size: 1.1rem;
  margin: 0 0 var(--spacing-xs) 0;
  color: var(--text-primary);
}

.item-location {
  font-size: 0.875rem;
  color: var(--text-secondary);
  margin: 0 0 var(--spacing-xs) 0;
  display: flex;
  align-items: center;
  gap: var(--spacing-xs);
}

.item-location i {
  color: var(--primary-color);
}

.item-quantity {
  font-size: 0.875rem;
  color: var(--text-secondary);
  margin: 0;
}

/* Item Price */
.item-price {
  text-align: right;
  margin-right: var(--spacing-md);
}

.price-per-unit {
  font-size: 0.75rem;
  color: var(--text-secondary);
  margin-bottom: var(--spacing-xs);
}

.price-total {
  font-size: 1.25rem;
  font-weight: 600;
  color: var(--primary-color);
}

/* Remove Button */
.remove-btn {
  flex-shrink: 0;
}

/* Empty Cart State */
.empty-cart {
  text-align: center;
  padding: var(--spacing-xl) var(--spacing-lg);
}

.empty-cart i {
  font-size: 4rem;
  color: var(--text-secondary);
  margin-bottom: var(--spacing-md);
}

.empty-cart h3 {
  color: var(--text-primary);
  margin-bottom: var(--spacing-sm);
}

.empty-cart p {
  color: var(--text-secondary);
  margin-bottom: var(--spacing-lg);
}

/* Cart Summary */
.cart-summary {
  background: var(--surface);
  border-radius: var(--radius-lg);
  padding: var(--spacing-lg);
  box-shadow: var(--shadow-sm);
  border: 2px solid var(--primary-color);
}

.summary-row {
  display: flex;
  justify-content: space-between;
  padding: var(--spacing-sm) 0;
  font-size: 0.975rem;
}

.summary-row.total {
  border-top: 2px solid var(--border-color);
  margin-top: var(--spacing-sm);
  padding-top: var(--spacing-md);
  font-size: 1.25rem;
  color: var(--primary-color);
}

/* Responsive Design */
@media (max-width: 768px) {
  .cart-header {
    flex-direction: column;
    align-items: stretch;
  }
  
  .cart-header button {
    width: 100%;
  }
  
  .cart-item {
    flex-direction: column;
    align-items: flex-start;
    text-align: left;
  }
  
  .item-price {
    width: 100%;
    text-align: left;
    margin-right: 0;
    margin-top: var(--spacing-sm);
  }
  
  .remove-btn {
    width: 100%;
  }
}
</style>
