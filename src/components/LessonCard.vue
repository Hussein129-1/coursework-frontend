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
  <!-- Card wrapper for a single lesson inside the grid -->
  <article class="lesson-card">
    <!-- Media section showing the lesson icon/image -->
    <figure class="lesson-card__media">
      <img
        :src="imageSrc"
        :alt="`${lesson.subject} icon`"
        loading="lazy"
        @error="handleImageError"
      />
    </figure>
    <!-- Text content area for lesson details -->
    <div class="lesson-card__body">
      <!-- Lesson title (subject) -->
      <h3 class="lesson-card__title">{{ lesson.subject }}</h3>
      <!-- Location text with a small map-marker icon -->
      <p class="lesson-card__location">
        <i class="fas fa-map-marker-alt"></i>
        {{ lesson.location }}
      </p>
      <!-- Price and remaining spaces information -->
      <div class="lesson-card__meta">
        <span class="lesson-card__price">£{{ lesson.price }}</span>
        <span class="lesson-card__spaces" :class="{ 'lesson-card__spaces--low': lesson.spaces < 3 }">
          {{ lesson.spaces }} {{ lesson.spaces === 1 ? 'space' : 'spaces' }} left
        </span>
      </div>
      <!-- Button to add this lesson to the shopping cart -->
      <button
        class="lesson-card__action"
        :disabled="lesson.spaces === 0"
        @click="addToCart"
      >
        <!-- Icon switches depending on whether the lesson is sold out -->
        <i class="fas" :class="lesson.spaces === 0 ? 'fa-ban' : 'fa-cart-plus'"></i>
        <span>{{ lesson.spaces > 0 ? 'Add to cart' : 'Sold out' }}</span>
      </button>
    </div>
  </article>
</template>

<script setup>
// Import Vue helpers for reactive state and reacting to changes
import { ref, watch } from 'vue';
// Import helper that builds full URLs for lesson images served by the backend
import { ASSET_ENDPOINTS } from '../config.js';

// Define the props expected from the parent component (lesson data object)
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

const emit = defineEmits(['add-to-cart']);

// Pre-computed URL for the generic fallback lesson image
const fallbackImage = ASSET_ENDPOINTS.lessonImage('default-lesson.svg');
// Reactive image source used in the <img> tag in the template above
const imageSrc = ref(props.lesson.imageUrl || fallbackImage);

// Watch for changes to the incoming lesson.imageUrl and keep imageSrc in sync
watch(
  () => props.lesson.imageUrl,
  (newUrl) => {
    imageSrc.value = newUrl || fallbackImage;
  }
);

// If the image fails to load, switch to the fallback image once
const handleImageError = () => {
  if (imageSrc.value !== fallbackImage) {
    imageSrc.value = fallbackImage;
  }
};

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
  background: rgba(255, 255, 255, 0.95);
  border: 1px solid rgba(148, 163, 184, 0.2);
  border-radius: var(--radius-lg);
  overflow: hidden;
  display: grid;
  grid-template-rows: 180px auto;
  box-shadow: var(--shadow-sm);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  height: 100%;
}

.lesson-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 35px rgba(15, 23, 42, 0.15);
}

.lesson-card__media {
  margin: 0;
  background: var(--surface);
  display: flex;
  align-items: center;
  justify-content: center;
}

.lesson-card__media img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.lesson-card__body {
  display: grid;
  gap: var(--spacing-md);
  padding: var(--spacing-lg);
}

.lesson-card__title {
  margin: 0;
  font-size: 1.1rem;
  font-weight: 600;
  color: var(--text-primary);
}

.lesson-card__location {
  margin: 0;
  display: inline-flex;
  align-items: center;
  gap: var(--spacing-xs);
  color: var(--text-secondary);
  font-size: 0.9rem;
}

.lesson-card__location i {
  color: var(--primary-color);
}

.lesson-card__meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.95rem;
  color: var(--text-primary);
}

.lesson-card__price {
  font-weight: 600;
}

.lesson-card__spaces {
  font-size: 0.85rem;
  color: var(--text-secondary);
}

.lesson-card__spaces--low {
  color: var(--danger-color);
  font-weight: 600;
}

.lesson-card__action {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: var(--spacing-xs);
  border: none;
  border-radius: var(--radius-md);
  padding: 0.75rem;
  font-weight: 600;
  background: var(--primary-color);
  color: #fff;
  cursor: pointer;
  transition: background 0.2s ease;
}

.lesson-card__action:hover:not(:disabled) {
  background: var(--primary-hover);
}

.lesson-card__action:disabled {
  background: rgba(107, 114, 128, 0.35);
  cursor: not-allowed;
}

@media (max-width: 768px) {
  .lesson-card {
    grid-template-rows: 160px auto;
  }

  .lesson-card__body {
    padding: var(--spacing-md);
  }
}
</style>
