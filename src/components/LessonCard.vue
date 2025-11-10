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
  <div class="lesson-card bg-white rounded-xl shadow-sm hover:shadow-lg border border-gray-100 transition">
    <!-- Icon Section - Large icon for visual appeal -->
    <div class="lesson-icon-container">
      <div :class="['lesson-icon-circle', 'mx-auto', 'bg-gradient-to-br', iconColor]">
        <i :class="['fas', lessonIcon]"></i>
      </div>
    </div>
    
    <!-- Content Section -->
    <div class="lesson-content p-4">
      <!-- Lesson subject/title -->
      <h3 class="lesson-subject">{{ lesson.subject }}</h3>
      
      <!-- Lesson description -->
      <p class="lesson-description">{{ lesson.description }}</p>
      
      <!-- Lesson details grid -->
      <div class="lesson-details grid grid-cols-3 gap-2">
        <!-- Location -->
        <div class="detail-item flex items-center gap-1">
          <i class="fas fa-map-marker-alt text-red-500"></i>
          <span class="text-sm text-gray-600">{{ lesson.location }}</span>
        </div>
        
        <!-- Price -->
        <div class="detail-item flex items-center gap-1">
          <i class="fas fa-pound-sign text-green-600"></i>
          <span class="text-sm font-semibold text-gray-700">£{{ lesson.price }}</span>
        </div>
        
        <!-- Available spaces -->
        <div class="detail-item flex items-center gap-1">
          <i class="fas fa-users text-blue-500"></i>
          <span class="text-sm text-gray-600">{{ lesson.spaces }}</span>
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
        class="btn-primary add-to-cart-btn w-full justify-center mt-2"
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

// Map subjects to colors
const subjectColors = {
  'Mathematics': 'from-blue-500 to-blue-600',
  'English Literature': 'from-amber-500 to-amber-600',
  'Science': 'from-green-500 to-green-600',
  'Computer Programming': 'from-purple-500 to-purple-600',
  'Art & Design': 'from-pink-500 to-pink-600',
  'Music Theory': 'from-indigo-500 to-indigo-600',
  'Physical Education': 'from-red-500 to-red-600',
  'History': 'from-yellow-600 to-yellow-700',
  'Geography': 'from-teal-500 to-teal-600',
  'Spanish Language': 'from-orange-500 to-orange-600',
  'Chemistry': 'from-cyan-500 to-cyan-600',
  'Drama & Theatre': 'from-rose-500 to-rose-600',
  'Biology': 'from-lime-500 to-lime-600',
  'Physics': 'from-violet-500 to-violet-600',
  'Economics': 'from-emerald-500 to-emerald-600'
};

// Computed property for lesson icon
const lessonIcon = computed(() => {
  return subjectIcons[props.lesson.subject] || 'fa-book';
});

// Computed property for icon color gradient
const iconColor = computed(() => {
  return subjectColors[props.lesson.subject] || 'from-indigo-500 to-indigo-600';
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
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 2.5rem;
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
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
