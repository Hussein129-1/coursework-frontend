<!--
  ========================================
  CHECKOUT FORM COMPONENT
  ========================================
  This component handles the checkout process with form validation
  It collects customer name and phone number, validates them, and submits the order
  
  PROPS:
  - cartItems: Array of cart items (for order submission)
  - isSubmitting: Boolean indicating if order is being submitted
  
  EMITS:
  - submit-order: When form is valid and user clicks checkout
-->

<template>
  <!-- Outer wrapper for the checkout card shown next to the cart items -->
  <div class="checkout-form">
    <!-- Form Title -->
    <h3>
      <i class="fas fa-user-check"></i>
      Customer Information
    </h3>
    
    <!-- Checkout Form (submit prevented so we can handle it in Vue) -->
    <form @submit.prevent="handleSubmit">
      <!-- Name Input Field -->
      <div class="form-group">
        <label for="customerName">
          Full Name <span class="required">*</span>
        </label>
        <!--
          v-model: Two-way data binding
          Keeps input value in sync with customerName variable
          
          @input: Event listener that runs on every keystroke
          Calls validateName method to check if input is valid
        -->
        <input
          id="customerName"
          v-model="customerName"
          @input="validateName"
          type="text"
          placeholder="Enter your full name"
          :class="{ 'input-error': nameError }"
          required
        />
        <!--
          v-if: Conditional rendering
          Only shows error message when nameError exists
        -->
        <span v-if="nameError" class="error-message">
          <i class="fas fa-exclamation-circle"></i>
          {{ nameError }}
        </span>
        <!-- Help text shown when no error -->
        <span v-else class="help-text">
          Letters only (A-Z, spaces allowed)
        </span>
      </div>
      
      <!-- Phone Number Input Field -->
      <div class="form-group">
        <label for="customerPhone">
          Phone Number <span class="required">*</span>
        </label>
        <input
          id="customerPhone"
          v-model="customerPhone"
          @input="validatePhone"
          type="tel"
          placeholder="Enter your phone number"
          :class="{ 'input-error': phoneError }"
          required
        />
        <span v-if="phoneError" class="error-message">
          <i class="fas fa-exclamation-circle"></i>
          {{ phoneError }}
        </span>
        <span v-else class="help-text">
          Numbers only (0-9)
        </span>
      </div>
      
      <!-- Submit Button -->
      <!--
        :disabled: Button is disabled if form is invalid or submitting
        :class: Conditionally applies CSS classes
      -->
      <button
        type="submit"
        class="btn-success checkout-btn"
        :disabled="!isFormValid || isSubmitting"
        :class="{ 'btn-loading': isSubmitting }"
      >
        <!-- Show spinner icon when submitting -->
        <i :class="isSubmitting ? 'fas fa-spinner fa-spin' : 'fas fa-check-circle'"></i>
        {{ isSubmitting ? 'Processing...' : 'Complete Checkout' }}
      </button>
      
      <!-- Form validation summary shown whenever the form is currently invalid -->
      <div v-if="!isFormValid" class="validation-summary">
        <i class="fas fa-info-circle"></i>
        Please fill in all required fields correctly
      </div>
    </form>
  </div>
</template>

<script setup>
// ========================================
// IMPORTS
// ========================================
import { ref, computed } from 'vue';

// ========================================
// PROPS (Data from parent)
// ========================================
const props = defineProps({
  cartItems: {
    type: Array,
    // Parent (App.vue) passes the current cart contents for order creation
    required: true
  },
  isSubmitting: {
    type: Boolean,
    default: false
  }
});

// ========================================
// EMITS (Events to parent)
// ========================================
const emit = defineEmits(['submit-order']);

// ========================================
// REACTIVE STATE
// ========================================
// ref() creates reactive variables that Vue tracks for changes
// When these change, Vue automatically updates the template

// Customer information
const customerName = ref('');
const customerPhone = ref('');

// Validation error messages
const nameError = ref('');
const phoneError = ref('');

// ========================================
// COMPUTED PROPERTIES
// ========================================

/**
 * Check if the form is valid
 * Form is valid when:
 * 1. Name is not empty
 * 2. Phone is not empty
 * 3. No validation errors exist
 */
const isFormValid = computed(() => {
  return (
    customerName.value.trim() !== '' &&
    customerPhone.value.trim() !== '' &&
    !nameError.value &&
    !phoneError.value
  );
});

// ========================================
// VALIDATION METHODS
// ========================================

/**
 * Validate customer name
 * Rules: Only letters and spaces allowed
 * Uses Regular Expression (regex) for pattern matching
 */
const validateName = () => {
  const name = customerName.value.trim();
  
  // Check if name is empty
  if (name === '') {
    nameError.value = 'Name is required';
    return;
  }
  
  // Regular Expression explanation:
  // ^       : Start of string
  // [A-Za-z]: Match any letter (uppercase or lowercase)
  // \s      : Match space character
  // +       : One or more of the preceding characters
  // $       : End of string
  // This ensures ONLY letters and spaces are allowed
  const namePattern = /^[A-Za-z\s]+$/;
  
  if (!namePattern.test(name)) {
    nameError.value = 'Name must contain only letters and spaces';
    return;
  }
  
  // Check minimum length
  if (name.length < 2) {
    nameError.value = 'Name must be at least 2 characters';
    return;
  }
  
  // If all validations pass, clear error
  nameError.value = '';
};

/**
 * Validate phone number
 * Rules: Only numbers allowed
 * Uses Regular Expression for pattern matching
 */
const validatePhone = () => {
  const phone = customerPhone.value.trim();
  
  // Check if phone is empty
  if (phone === '') {
    phoneError.value = 'Phone number is required';
    return;
  }
  
  // Regular Expression explanation:
  // ^      : Start of string
  // [0-9]  : Match any digit (0 through 9)
  // +      : One or more of the preceding characters
  // $      : End of string
  // This ensures ONLY numbers are allowed
  const phonePattern = /^[0-9]+$/;
  
  if (!phonePattern.test(phone)) {
    phoneError.value = 'Phone number must contain only numbers';
    return;
  }
  
  // Check minimum length (typical phone number)
  if (phone.length < 10) {
    phoneError.value = 'Phone number must be at least 10 digits';
    return;
  }
  
  // Check maximum length
  if (phone.length > 15) {
    phoneError.value = 'Phone number must be at most 15 digits';
    return;
  }
  
  // If all validations pass, clear error
  phoneError.value = '';
};

// ========================================
// FORM SUBMISSION
// ========================================

/**
 * Handle form submission
 * Validates form one last time and emits order data to parent
 */
const handleSubmit = () => {
  // Run validation on both fields
  validateName();
  validatePhone();
  
  // Only proceed if form is valid
  if (isFormValid.value) {
    // Create order data object
    const orderData = {
      name: customerName.value.trim(),
      phone: customerPhone.value.trim()
    };
    
    // Emit event to parent with order data
    // Parent component will handle API submission
    emit('submit-order', orderData);
  }
};

/**
 * Reset form (can be called from parent using template ref)
 */
const resetForm = () => {
  customerName.value = '';
  customerPhone.value = '';
  nameError.value = '';
  phoneError.value = '';
};

// Expose resetForm method so parent can call it
// defineExpose is a Vue 3 compiler macro
defineExpose({ resetForm });
</script>

<style scoped>
/* ========================================
   COMPONENT STYLES
   ======================================== */

.checkout-form {
  background: var(--surface);
  border-radius: var(--radius-lg);
  padding: var(--spacing-lg);
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--border-color);
}

.checkout-form h3 {
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
  margin-bottom: var(--spacing-lg);
  color: var(--text-primary);
  padding-bottom: var(--spacing-md);
  border-bottom: 2px solid var(--border-color);
}

.checkout-form h3 i {
  color: var(--success-color);
}

/* Form Group (label + input + error message) */
.form-group {
  margin-bottom: var(--spacing-lg);
}

.form-group label {
  display: block;
  font-weight: 500;
  margin-bottom: var(--spacing-sm);
  color: var(--text-primary);
}

.required {
  color: var(--danger-color);
}

/* Input Fields */
.form-group input {
  width: 100%;
  padding: 0.75rem;
  border: 2px solid var(--border-color);
  border-radius: var(--radius-md);
  font-size: 1rem;
  transition: all 0.2s ease;
}

.form-group input:focus {
  outline: none;
  border-color: var(--primary-color);
  box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
}

/* Input with error */
.input-error {
  border-color: var(--danger-color) !important;
}

.input-error:focus {
  box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1) !important;
}

/* Error Message */
.error-message {
  display: flex;
  align-items: center;
  gap: var(--spacing-xs);
  color: var(--danger-color);
  font-size: 0.875rem;
  margin-top: var(--spacing-sm);
}

.error-message i {
  font-size: 1rem;
}

/* Help Text */
.help-text {
  display: block;
  color: var(--text-secondary);
  font-size: 0.875rem;
  margin-top: var(--spacing-sm);
}

/* Checkout Button */
.checkout-btn {
  width: 100%;
  padding: 1rem;
  font-size: 1rem;
  font-weight: 600;
  margin-top: var(--spacing-md);
  justify-content: center;
}

.btn-loading {
  opacity: 0.7;
  cursor: wait;
}

/* Validation Summary */
.validation-summary {
  margin-top: var(--spacing-md);
  padding: var(--spacing-md);
  background: rgba(239, 68, 68, 0.1);
  border: 1px solid var(--danger-color);
  border-radius: var(--radius-md);
  color: var(--danger-color);
  font-size: 0.875rem;
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
}

/* Responsive Design */
@media (max-width: 768px) {
  .checkout-form {
    padding: var(--spacing-md);
  }
}
</style>
