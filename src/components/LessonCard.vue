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
    <!-- Icon Section - Large icon for visual appeal -->
    <div class="lesson-icon-container">
      <div class="lesson-icon-circle">
        <i :class="['fas', lessonIcon]"></i>
      </div>
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
import { computed } from 'vue';

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
    //   image: String,
    //   description: String
    // }
  }
});

// Define emits - Events this component can send to parent
// defineEmits is a Vue 3 compiler macro
const emit = defineEmits(['add-to-cart']);

// Map subjects to Font Awesome icons
const subjectIcons = {
  'Mathematics': 'fa-calculator',
  'English Literature': 'fa-book',
  'Science': 'fa-flask',
  'Computer Programming': 'fa-laptop-code',
  'Art & Design': 'fa-palette',
  'Music Theory': 'fa-music',
  'Physical Education': 'fa-running',
  'History': 'fa-landmark',
  'Geography': 'fa-globe',
  'Spanish Language': 'fa-language',
  'Chemistry': 'fa-atom',
  'Drama & Theatre': 'fa-theater-masks',
  'Biology': 'fa-dna',
  'Physics': 'fa-rocket',
  'Economics': 'fa-chart-line'
};

// Computed property for lesson icon
const lessonIcon = computed(() => {
  return subjectIcons[props.lesson.subject] || 'fa-book';
});

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
.lesson-icon-container {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: var(--spacing-lg) 0;
  background: linear-gradient(135deg, rgba(79, 70, 229, 0.05), rgba(139, 92, 246, 0.05));
  border-radius: var(--radius-lg) var(--radius-lg) 0 0;
  margin: calc(-1 * var(--spacing-md)) calc(-1 * var(--spacing-md)) var(--spacing-md) calc(-1 * var(--spacing-md));
}

.lesson-icon-circle {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--primary-color), var(--primary-hover));
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 2.5rem;
  box-shadow: 0 8px 16px rgba(79, 70, 229, 0.3);
  transition: all 0.3s ease;
}

.lesson-card:hover .lesson-icon-circle {
  transform: scale(1.1) rotate(5deg);
  box-shadow: 0 12px 24px rgba(79, 70, 229, 0.4);
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
