<!--
  ========================================
  LESSON LIST COMPONENT
  ========================================
  This component displays all lessons in a grid layout with sorting functionality
  
  PROPS:
  - lessons: Array of lesson objects to display
  - sortBy: Current sorting attribute (subject, location, price, spaces)
  - sortOrder: Current sort order (asc or desc)
  
  EMITS:
  - add-to-cart: When a lesson is added to cart
  - update-sort: When sorting options change
-->

<template>
  <!-- Section that contains the toolbar (search + sort) and the grid of lessons -->
  <section class="lesson-list">
    <!-- Toolbar at the top of the list -->
    <header class="lesson-toolbar">
      <!-- Search controls: label, input, clear button and loading spinner -->
      <div class="toolbar-search">
        <label class="toolbar-label" for="lesson-search">Search</label>
        <div class="toolbar-field">
          <!-- Magnifying-glass icon for visual cue -->
          <i class="fas fa-search toolbar-icon" aria-hidden="true"></i>
          <!-- Search input bound to searchQuery and emitting search events to parent -->
          <input
            id="lesson-search"
            class="toolbar-input"
            v-model="searchQuery"
            @input="handleSearch"
            @keyup.esc="clearSearch"
            type="search"
            placeholder="Search subject, location or price"
            :aria-busy="isBusy"
          />
          <!-- Clear button only appears when there is text in the search box -->
          <button
            v-if="searchQuery"
            class="toolbar-clear"
            @click="clearSearch"
            aria-label="Clear search"
          >
            ×
          </button>
          <!-- Small spinner shown while a backend search request is in progress -->
          <span v-if="isBusy" class="toolbar-spinner" aria-hidden="true"></span>
        </div>
      </div>
      <!-- Sorting controls: user can choose attribute and sort order -->
      <div class="toolbar-sort">
        <label class="toolbar-label" for="sortBy">Sort by</label>
        <div class="toolbar-field toolbar-field--inline">
          <select id="sortBy" v-model="localSortBy" @change="updateSorting">
            <option value="subject">Subject</option>
            <option value="location">Location</option>
            <option value="price">Price</option>
            <option value="spaces">Spaces</option>
          </select>
          <select v-model="localSortOrder" @change="updateSorting" aria-label="Sort direction">
            <option value="asc">Ascending</option>
            <option value="desc">Descending</option>
          </select>
        </div>
      </div>
      <!-- Small text summary showing how many lessons are currently visible -->
      <p class="toolbar-summary">
        {{ sortedLessons.length }} {{ sortedLessons.length === 1 ? 'lesson' : 'lessons' }}
      </p>
    </header>

    <!-- Show a responsive grid of LessonCard components when there are lessons to display -->
    <div v-if="sortedLessons.length" class="lesson-grid">
      <LessonCard
        v-for="lesson in sortedLessons"
        :key="lesson._id"
        :lesson="lesson"
        @add-to-cart="handleAddToCart"
      />
    </div>

    <!-- Message shown when no lessons match the current search or sorting filters -->
    <div v-else class="lesson-empty">
      <p>No lessons match your filters yet. Try adjusting search or sorting.</p>
    </div>
  </section>
</template>

<script setup>
// ========================================
// IMPORTS
// ========================================
import { computed, ref } from 'vue';
import LessonCard from './LessonCard.vue';

// Debounce timer for search
let searchTimeout = null;

// ========================================
// PROPS (Data from parent)
// ========================================
const props = defineProps({
  lessons: {
    type: Array,
    required: true,
    default: () => []
  },
  sortBy: {
    type: String,
    default: 'subject'
  },
  sortOrder: {
    type: String,
    default: 'asc'
  },
  isSearching: {
    type: Boolean,
    default: false
  }
});

// ========================================
// EMITS (Events to parent)
// ========================================
const emit = defineEmits(['add-to-cart', 'update-sort', 'search', 'clear-search']);

// ========================================
// LOCAL STATE
// ========================================
// ref() creates reactive data that Vue tracks for changes
// When these change, Vue automatically updates the template
const localSortBy = ref(props.sortBy);
const localSortOrder = ref(props.sortOrder);
const searchQuery = ref('');

// ========================================
// COMPUTED PROPERTIES
// ========================================
// computed() creates a value that automatically recalculates
// when its dependencies change
// It's cached - only recalculates when dependencies change

/**
 * Sort the lessons based on current sorting preferences
 * This is a computed property, so it automatically updates
 * whenever lessons, localSortBy, or localSortOrder changes
 */
const sortedLessons = computed(() => {
  const lessonsCopy = [...props.lessons];

  lessonsCopy.sort((a, b) => {
    let aValue = a[localSortBy.value];
    let bValue = b[localSortBy.value];

    if (typeof aValue === 'string') {
      aValue = aValue.toLowerCase();
      bValue = bValue.toLowerCase();
    }

    if (aValue < bValue) {
      return localSortOrder.value === 'asc' ? -1 : 1;
    }
    if (aValue > bValue) {
      return localSortOrder.value === 'asc' ? 1 : -1;
    }
    return 0;
  });

  return lessonsCopy;
});

const isBusy = computed(() => props.isSearching && searchQuery.value.trim().length > 0);

// ========================================
// METHODS (Functions)
// ========================================

/**
 * Handle sort changes
 * Emits event to parent component when sorting changes
 */
const updateSorting = () => {
  emit('update-sort', {
    sortBy: localSortBy.value,
    sortOrder: localSortOrder.value
  });
};

/**
 * Handle add to cart event from LessonCard
 * Passes the event up to the parent component (App.vue)
 */
const handleAddToCart = (lesson) => {
  emit('add-to-cart', lesson);
};

/**
 * Handle search input with a small debounce
 * Waits 200ms after typing before emitting the search query to the parent
 */
const handleSearch = () => {
  if (searchTimeout) {
    clearTimeout(searchTimeout);
  }

  searchTimeout = setTimeout(() => {
    // Emit the trimmed search query string to App.vue
    emit('search', searchQuery.value.trim());
  }, 200);
};

/**
 * Clear the current search query and reset the lesson list
 * Also cancels any pending debounced search call
 */
const clearSearch = () => {
  searchQuery.value = '';
  if (searchTimeout) {
    clearTimeout(searchTimeout);
  }
  emit('clear-search');
};
</script>

<style scoped>
.lesson-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xl);
}

.lesson-toolbar {
  display: grid;
  gap: var(--spacing-md);
  padding: var(--spacing-lg);
  background: rgba(255, 255, 255, 0.92);
  border: 1px solid rgba(148, 163, 184, 0.2);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
}

.toolbar-search,
.toolbar-sort {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.toolbar-label {
  font-size: 0.7rem;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--text-secondary);
}

.toolbar-field {
  display: grid;
  grid-auto-flow: column;
  grid-auto-columns: auto;
  align-items: center;
  gap: var(--spacing-sm);
  position: relative;
}

.toolbar-field--inline {
  grid-auto-columns: 1fr;
}

.toolbar-icon {
  color: var(--text-secondary);
}

.toolbar-input {
  width: 100%;
  border-radius: var(--radius-md);
  border: 1px solid var(--border-color);
  padding: 0.65rem 0.75rem 0.65rem 0.75rem;
  font-size: 0.95rem;
  font-family: inherit;
}

.toolbar-clear {
  border: none;
  background: transparent;
  font-size: 1.2rem;
  line-height: 1;
  cursor: pointer;
  color: var(--text-secondary);
  padding: 0 0.25rem;
}

.toolbar-spinner {
  width: 1rem;
  height: 1rem;
  border-radius: 50%;
  border: 2px solid rgba(148, 163, 184, 0.35);
  border-top-color: var(--primary-color);
  animation: spin 0.6s linear infinite;
}

.toolbar-summary {
  margin: 0;
  font-weight: 600;
  color: var(--text-secondary);
}

.lesson-grid {
  display: grid;
  gap: var(--spacing-lg);
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
}

.lesson-empty {
  padding: var(--spacing-xl);
  text-align: center;
  background: rgba(255, 255, 255, 0.85);
  border-radius: var(--radius-lg);
  border: 1px dashed rgba(148, 163, 184, 0.4);
  color: var(--text-secondary);
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

@media (min-width: 768px) {
  .lesson-toolbar {
    grid-template-columns: 2fr 1.5fr auto;
    align-items: center;
  }

  .toolbar-field--inline select {
    min-width: 120px;
  }
}
</style>
