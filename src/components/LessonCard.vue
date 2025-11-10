<!--
  ========================================
  LESSON CARD COMPONENT
  ========================================
  This component displays a single lesson with all its details
  It receives lesson data from the parent component (App.vue) as a "prop"
  
  PROPS (Data passed from parent):
  - lesson: Object containing lesson details (subject, location, price, spaces, icon)
  
  EMITS (Events sent to parent):
  - add-to-cart: Triggered when user clicks "Add to Cart" button
-->

<template>
  <!-- Main card container -->
  <div class="lesson-card">
    <!-- Icon Section - Displays Font Awesome icon for the lesson -->
    <div class="lesson-icon">
      <!-- :class dynamically binds the icon class from lesson data -->
      <i :class="['fas', lesson.icon]"></i>
    </div>
    
    <!-- Content Section -->
    <div class="lesson-content">
      <!-- Lesson subject/title -->
      <h3 class="lesson-subject">{{ lesson.subject }}</h3>
      
      <!-- Lesson description -->
      <p class="lesson-description">{{ lesson.description }}</p>
      
      <!-- Lesson details grid -->
      <div class="lesson-details">
        <!-- Location -->
        <div class="detail-item">
          <i class="fas fa-map-marker-alt"></i>
          <span>{{ lesson.location }}</span>
        </div>
        
        <!-- Price -->
        <div class="detail-item">
          <i class="fas fa-pound-sign"></i>
          <span>£{{ lesson.price }}</span>
        </div>
        
        <!-- Available spaces -->
        <div class="detail-item">
          <i class="fas fa-users"></i>
          <span>{{ lesson.spaces }} spaces left</span>
        </div>
      </div>
    </div>
    
    <!-- Footer Section with Add to Cart button -->
    <div class="lesson-footer">
      <!-- 
        Button to add lesson to cart
        :disabled - Disables button when no spaces are available
        @click - Calls addToCart method when clicked (v-on directive)
        :class - Conditionally adds 'btn-disabled' class when spaces = 0
      -->
      <button 
        class="btn-primary add-to-cart-btn"
        :disabled="lesson.spaces === 0"
        :class="{ 'btn-disabled': lesson.spaces === 0 }"
        @click="addToCart"
      >
        <i class="fas fa-shopping-cart"></i>
        <!-- Show different text based on availability -->
        {{ lesson.spaces > 0 ? 'Add to Cart' : 'Sold Out' }}
      </button>
    </div>
  </div>
</template>

<script setup>
// ========================================
// COMPONENT LOGIC (using Vue 3 Composition API)
// ========================================

// Define props - Data this component receives from parent
// defineProps is a Vue 3 compiler macro (no import needed)
const props = defineProps({
  lesson: {
    type: Object,      // Must be an object
    required: true,    // This prop is mandatory
    // Expected structure:
    // {
    //   _id: String,
    //   subject: String,
    //   location: String,
    //   price: Number,
    //   spaces: Number,
    //   icon: String,
    //   description: String
    // }
  }
});

// Define emits - Events this component can send to parent
// defineEmits is a Vue 3 compiler macro
const emit = defineEmits(['add-to-cart']);

/**
 * Add to Cart Handler
 * This function is called when the "Add to Cart" button is clicked
 * It emits an event to the parent component with the lesson data
 */
const addToCart = () => {
  // Emit 'add-to-cart' event to parent, passing the lesson object
  // The parent component (App.vue) will listen for this event
  emit('add-to-cart', props.lesson);
};
</script>

<style scoped>
/* 
  ========================================
  COMPONENT STYLES
  ========================================
  "scoped" means these styles only apply to this component
  They won't affect other components in the app
*/

.lesson-card {
  /* Card appearance */
  background: var(--surface);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
  padding: var(--spacing-lg);
  
  /* Layout - Flexbox for vertical arrangement */
  display: flex;
  flex-direction: column;
  gap: var(--spacing-md);
  
  /* Smooth transition for hover effect */
  transition: all 0.3s ease;
  
  /* Border for better definition */
  border: 1px solid var(--border-color);
  
  /* Ensure card takes full height of grid cell */
  height: 100%;
}

/* Hover effect - lift card and add shadow */
.lesson-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-lg);
  border-color: var(--primary-color);
}

/* Icon container */
.lesson-icon {
  /* Circular icon background */
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--primary-color), var(--primary-hover));
  
  /* Center the icon */
  display: flex;
  align-items: center;
  justify-content: center;
  
  /* Icon color and size */
  color: white;
  font-size: 1.5rem;
  
  /* Add slight shadow */
  box-shadow: var(--shadow-md);
}

/* Content section - grows to fill space */
.lesson-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

/* Lesson subject/title */
.lesson-subject {
  font-size: 1.25rem;
  font-weight: 600;
  color: var(--text-primary);
  margin: 0;
}

/* Lesson description */
.lesson-description {
  font-size: 0.875rem;
  color: var(--text-secondary);
  margin: 0;
  line-height: 1.5;
}

/* Details grid - displays location, price, spaces */
.lesson-details {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
  margin-top: var(--spacing-sm);
}

/* Individual detail item */
.detail-item {
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
  font-size: 0.875rem;
  color: var(--text-secondary);
}

/* Detail icons */
.detail-item i {
  color: var(--primary-color);
  width: 16px;
  text-align: center;
}

/* Footer section with button */
.lesson-footer {
  border-top: 1px solid var(--border-color);
  padding-top: var(--spacing-md);
}

/* Add to Cart button */
.add-to-cart-btn {
  width: 100%;
  justify-content: center;
  font-weight: 600;
}

/* Disabled button appearance */
.btn-disabled {
  background-color: var(--danger-color) !important;
  cursor: not-allowed;
}

/* Responsive design for smaller screens */
@media (max-width: 768px) {
  .lesson-card {
    padding: var(--spacing-md);
  }
  
  .lesson-icon {
    width: 50px;
    height: 50px;
    font-size: 1.25rem;
  }
  
  .lesson-subject {
    font-size: 1.1rem;
  }
}
</style>
