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
  <article class="lesson-card">
    <figure class="lesson-media" v-if="lesson.imageUrl">
      <img
        :src="lesson.imageUrl"
        :alt="`${lesson.subject} illustration`"
        loading="lazy"
      />
    </figure>
    <div class="lesson-content">
      <header class="lesson-header">
        <h3 class="lesson-title">{{ lesson.subject }}</h3>
        <p class="lesson-description">{{ lesson.description }}</p>
      </header>
      <dl class="lesson-meta">
        <div class="lesson-meta__item">
          <dt>Location</dt>
          <dd>{{ lesson.location }}</dd>
        </div>
        <div class="lesson-meta__item">
          <dt>Price</dt>
          <dd>£{{ lesson.price }}</dd>
        </div>
        <div class="lesson-meta__item">
          <dt>Spaces</dt>
          <dd>{{ lesson.spaces }}</dd>
        </div>
      </dl>
      <button
        class="lesson-action"
        :disabled="lesson.spaces === 0"
        @click="addToCart"
      >
        {{ lesson.spaces > 0 ? 'Add to cart' : 'Sold out' }}
      </button>
    </div>
  </article>
</template>

<script setup>
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
  background: var(--surface);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-lg);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  height: 100%;
  box-shadow: var(--shadow-sm);
}

.lesson-media {
  margin: 0;
}

.lesson-media img {
  width: 100%;
  height: 180px;
  object-fit: cover;
  display: block;
}

.lesson-content {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-md);
  padding: var(--spacing-lg);
}

.lesson-header {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.lesson-title {
  margin: 0;
  font-size: 1.1rem;
  font-weight: 600;
  color: var(--text-primary);
}

.lesson-description {
  margin: 0;
  color: var(--text-secondary);
  font-size: 0.9rem;
}

.lesson-meta {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: var(--spacing-sm);
  margin: 0;
}

.lesson-meta__item {
  background: rgba(148, 163, 184, 0.08);
  border-radius: var(--radius-md);
  padding: var(--spacing-sm) var(--spacing-md);
}

.lesson-meta__item dt {
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--text-secondary);
  margin-bottom: 4px;
}

.lesson-meta__item dd {
  margin: 0;
  font-weight: 600;
  color: var(--text-primary);
}

.lesson-action {
  border: none;
  border-radius: var(--radius-md);
  padding: 0.75rem;
  font-weight: 600;
  background: var(--primary-color);
  color: #fff;
  cursor: pointer;
  transition: background 0.2s ease;
}

.lesson-action:hover:not(:disabled) {
  background: var(--primary-hover);
}

.lesson-action:disabled {
  background: rgba(107, 114, 128, 0.4);
  cursor: not-allowed;
}

@media (max-width: 768px) {
  .lesson-media img {
    height: 160px;
  }

  .lesson-content {
    padding: var(--spacing-md);
  }
}
</style>
