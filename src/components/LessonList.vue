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
  <section class="lesson-list">
    <header class="lesson-toolbar">
      <div class="toolbar-search">
        <label class="toolbar-label" for="lesson-search">Search</label>
        <div class="toolbar-field">
          <input
            id="lesson-search"
            v-model="searchQuery"
            @input="handleSearch"
            @keyup.esc="clearSearch"
            type="search"
            placeholder="Search by subject, location or price"
            :aria-busy="isSearching"
          />
          <button v-if="searchQuery" class="toolbar-clear" @click="clearSearch" aria-label="Clear search">
            ×
          </button>
        </div>
      </div>
      <div class="toolbar-sort">
        <label class="toolbar-label" for="sortBy">Sort by</label>
        <div class="toolbar-field">
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
      <p class="toolbar-summary">
        {{ sortedLessons.length }} {{ sortedLessons.length === 1 ? 'lesson' : 'lessons' }}
      </p>
    </header>

    <div v-if="sortedLessons.length" class="lesson-grid">
      <LessonCard
        v-for="lesson in sortedLessons"
        :key="lesson._id"
        :lesson="lesson"
        @add-to-cart="handleAddToCart"
      />
    </div>

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

const handleSearch = () => {
  if (searchTimeout) {
    clearTimeout(searchTimeout);
  }

  searchTimeout = setTimeout(() => {
    emit('search', searchQuery.value.trim());
  }, 200);
};

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
  gap: var(--spacing-lg);
  padding: var(--spacing-lg);
  background: rgba(255, 255, 255, 0.9);
  border-radius: var(--radius-lg);
  border: 1px solid rgba(148, 163, 184, 0.2);
  box-shadow: var(--shadow-sm);
}

.toolbar-search,
.toolbar-sort {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

.toolbar-label {
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--text-secondary);
}

.toolbar-field {
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
}

.toolbar-field input,
.toolbar-field select {
  flex: 1;
  border-radius: var(--radius-md);
  border: 1px solid var(--border-color);
  padding: 0.55rem 0.75rem;
  font-size: 0.95rem;
  font-family: inherit;
}

.toolbar-field select {
  flex: 0;
  min-width: 140px;
}

.toolbar-clear {
  border: none;
  background: transparent;
  font-size: 1.25rem;
  line-height: 1;
  cursor: pointer;
  color: var(--text-secondary);
  padding: 0 0.5rem;
}

.toolbar-summary {
  margin: 0;
  font-weight: 600;
  color: var(--text-secondary);
}

.lesson-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: var(--spacing-lg);
}

.lesson-empty {
  padding: var(--spacing-xl);
  text-align: center;
  background: rgba(255, 255, 255, 0.85);
  border-radius: var(--radius-lg);
  border: 1px dashed rgba(148, 163, 184, 0.4);
  color: var(--text-secondary);
}

@media (min-width: 768px) {
  .lesson-toolbar {
    grid-template-columns: 2fr 2fr auto;
    align-items: center;
  }

  .toolbar-field select:last-child {
    min-width: 120px;
  }
}
</style>
