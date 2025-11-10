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
  <div class="lesson-list-container">
    <!-- Search Bar Section -->
    <div class="search-bar mb-4">
      <div class="input-group input-group-lg shadow-sm">
        <span class="input-group-text bg-primary text-white">
          <i :class="isSearching ? 'fas fa-spinner fa-spin' : 'fas fa-search'"></i>
        </span>
        <input
          v-model="searchQuery"
          @input="handleSearch"
          @keyup.esc="clearSearch"
          type="text"
          placeholder="Search lessons by subject, location, price, or spaces..."
          class="form-control"
        />
        <button
          v-if="searchQuery"
          @click="clearSearch"
          class="btn btn-outline-danger"
          aria-label="Clear search"
        >
          <i class="fas fa-times"></i>
        </button>
      </div>
      <div class="alert alert-info mt-2 py-2 d-flex align-items-center small" role="alert">
        <i class="fas fa-info-circle me-2"></i>
        <span>Search across all lesson details. Results update as you type.</span>
        <span v-if="searchQuery" class="ms-auto">
          Press <kbd class="bg-light border rounded px-2 py-1">ESC</kbd> to clear
        </span>
      </div>
    </div>
    
    <!-- Sorting Controls Section -->
    <div class="sort-controls">
      <div class="sort-group">
        <label for="sortBy">
          <i class="fas fa-sort"></i>
          Sort By:
        </label>
        <!--
          v-model: Two-way data binding
          Creates a connection between the select element and the sortBy data
          When user changes selection, sortBy updates automatically
          When sortBy changes in code, the select updates automatically
        -->
        <select id="sortBy" v-model="localSortBy" @change="updateSorting">
          <option value="subject">Subject</option>
          <option value="location">Location</option>
          <option value="price">Price</option>
          <option value="spaces">Available Spaces</option>
        </select>
      </div>
      
      <div class="sort-group">
        <label for="sortOrder">
          <i class="fas fa-arrow-down-short-wide"></i>
          Order:
        </label>
        <select id="sortOrder" v-model="localSortOrder" @change="updateSorting">
          <option value="asc">Ascending</option>
          <option value="desc">Descending</option>
        </select>
      </div>
      
      <!-- Results counter -->
      <div class="results-count">
        <i class="fas fa-list"></i>
        {{ sortedLessons.length }} {{ sortedLessons.length === 1 ? 'lesson' : 'lessons' }} available
      </div>
    </div>
    
    <!-- Lessons Grid - display lesson cards in a responsive grid -->
    <div v-if="sortedLessons.length > 0" class="row row-cols-1 row-cols-md-2 row-cols-lg-3 row-cols-xl-4 g-4 lessons-grid">
      <div v-for="lesson in sortedLessons" :key="lesson._id" class="col">
        <LessonCard
          :lesson="lesson"
          @add-to-cart="handleAddToCart"
        />
      </div>
    </div>
    
    <!-- Empty State - shown when no lessons available -->
    <div v-else class="empty-state">
      <i class="fas fa-inbox"></i>
      <h3>No lessons available</h3>
      <p>Please check back later for new classes</p>
    </div>
  </div>
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
  // Create a copy of the lessons array to avoid mutating the original
  const lessonsCopy = [...props.lessons];
  
  // Sort the array based on selected attribute
  lessonsCopy.sort((a, b) => {
    let aValue = a[localSortBy.value];
    let bValue = b[localSortBy.value];
    
    // For string comparison (subject, location)
    if (typeof aValue === 'string') {
      aValue = aValue.toLowerCase();
      bValue = bValue.toLowerCase();
    }
    
    // Compare values
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

/**
 * Handle search input with debouncing
 */
const handleSearch = () => {
  if (searchTimeout) {
    clearTimeout(searchTimeout);
  }
  
  searchTimeout = setTimeout(() => {
    const query = searchQuery.value.trim();
    emit('search', query);
  }, 300);
};

/**
 * Clear search
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
/* ========================================
   COMPONENT STYLES
   ======================================== */

.lesson-list-container {
  width: 100%;
}

/* Sorting Controls */
.sort-controls {
  background: var(--surface);
  padding: var(--spacing-lg);
  border-radius: var(--radius-lg);
  margin-bottom: var(--spacing-xl);
  box-shadow: var(--shadow-sm);
  
  /* Flexbox layout for controls */
  display: flex;
  flex-wrap: wrap;
  gap: var(--spacing-lg);
  align-items: center;
}

.sort-group {
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
}

.sort-group label {
  font-weight: 500;
  color: var(--text-primary);
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
  white-space: nowrap;
}

.sort-group select {
  min-width: 150px;
  padding: 0.5rem;
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  background: white;
  cursor: pointer;
  font-size: 0.875rem;
}

.sort-group select:focus {
  outline: none;
  border-color: var(--primary-color);
  box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
}

/* Results counter */
.results-count {
  margin-left: auto;
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
  color: var(--text-secondary);
  font-weight: 500;
}

.results-count i {
  color: var(--primary-color);
}

/* Lessons Grid Layout */
.lessons-grid {
  /* CSS Grid for responsive layout */
  display: grid;
  
  /* 
    grid-template-columns: 
    - repeat(auto-fill, ...) creates as many columns as fit
    - minmax(280px, 1fr) each column is at least 280px, 
      and expands equally to fill space
    This creates a responsive grid that adapts to screen size
  */
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  
  /* Spacing between grid items */
  gap: var(--spacing-lg);
  
  /* Ensure grid items align to start */
  align-items: stretch;
}

/* Empty State */
.empty-state {
  text-align: center;
  padding: var(--spacing-xl);
  background: var(--surface);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
}

.empty-state i {
  font-size: 4rem;
  color: var(--text-secondary);
  margin-bottom: var(--spacing-md);
}

.empty-state h3 {
  color: var(--text-primary);
  margin-bottom: var(--spacing-sm);
}

.empty-state p {
  color: var(--text-secondary);
  margin: 0;
}

/* Responsive Design */
@media (max-width: 768px) {
  .sort-controls {
    flex-direction: column;
    align-items: stretch;
  }
  
  .sort-group {
    flex-direction: column;
    align-items: stretch;
  }
  
  .sort-group select {
    width: 100%;
  }
  
  .results-count {
    margin-left: 0;
    justify-content: center;
  }
  
  /* On small screens, make grid single column */
  .lessons-grid {
    grid-template-columns: 1fr;
  }
}
</style>
