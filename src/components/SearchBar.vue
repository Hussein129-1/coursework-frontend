<!--
  ========================================
  SEARCH BAR COMPONENT
  ========================================
  This component provides search functionality for lessons
  It implements "search as you type" - results update as user types
  
  PROPS:
  - isSearching: Boolean indicating if search is in progress
  
  EMITS:
  - search: Emits search query to parent component
  - clear-search: Emits when user clears the search
-->

<template>
  <div class="search-bar mb-8">
    <!-- Search Container -->
    <div class="search-container bg-white/90 backdrop-blur rounded-xl shadow-md border-2 border-indigo-100 ring-1 ring-indigo-100">
      <!-- Search Icon -->
      <div class="search-icon text-indigo-500">
        <!--
          Show spinner when searching, magnifying glass otherwise
          :class dynamically applies classes based on conditions
        -->
        <i :class="isSearching ? 'fas fa-spinner fa-spin' : 'fas fa-search'"></i>
      </div>
      
      <!-- Search Input -->
      <!--
        v-model: Two-way data binding with searchQuery
        @input: Fires on every keystroke, triggers search
        @keyup.esc: Fires when user presses Escape key, clears search
      -->
      <input
        v-model="searchQuery"
        @input="handleSearch"
        @keyup.esc="clearSearch"
        type="text"
        placeholder="Search lessons by subject, location, price, or spaces..."
        class="search-input placeholder:text-slate-400"
      />
      
      <!-- Clear Button -->
      <!--
        v-if: Only show when there's text in the search box
        @click: Clears the search when clicked
      -->
      <button
        v-if="searchQuery"
        @click="clearSearch"
        class="clear-btn text-gray-400 hover:text-red-500"
        aria-label="Clear search"
      >
        <i class="fas fa-times"></i>
      </button>
    </div>
    
    <!-- Search Help Text -->
    <div class="search-help bg-gradient-to-r from-indigo-50 via-purple-50 to-pink-50 border border-indigo-100 rounded-md">
      <i class="fas fa-info-circle"></i>
      <span>Search across all lesson details. Results update as you type.</span>
      <span v-if="searchQuery" class="search-tip">
        Press <kbd>ESC</kbd> to clear search
      </span>
    </div>
  </div>
</template>

<script setup>
// ========================================
// IMPORTS
// ========================================
import { ref } from 'vue';

// ========================================
// PROPS (Data from parent)
// ========================================
const props = defineProps({
  isSearching: {
    type: Boolean,
    default: false
  }
});

// ========================================
// EMITS (Events to parent)
// ========================================
const emit = defineEmits(['search', 'clear-search']);

// ========================================
// REACTIVE STATE
// ========================================
// ref() creates a reactive variable
const searchQuery = ref('');

// Debounce timer - prevents too many rapid search requests
let searchTimeout = null;

// ========================================
// METHODS
// ========================================

/**
 * Handle search input
 * Implements debouncing - waits 300ms after user stops typing
 * before triggering the search. This prevents excessive API calls.
 */
const handleSearch = () => {
  // Clear any existing timeout
  if (searchTimeout) {
    clearTimeout(searchTimeout);
  }
  
  // Set a new timeout
  // The search will only execute after 300ms of no typing
  searchTimeout = setTimeout(() => {
    const query = searchQuery.value.trim();
    
    // Emit search event to parent
    // Parent component will handle the actual search logic
    emit('search', query);
  }, 300); // 300ms delay
};

/**
 * Clear search input and results
 * Resets the search query and notifies parent
 */
const clearSearch = () => {
  // Clear the search input
  searchQuery.value = '';
  
  // Clear any pending timeout
  if (searchTimeout) {
    clearTimeout(searchTimeout);
  }
  
  // Notify parent to clear search results
  emit('clear-search');
};
</script>

<style scoped>
/* ========================================
   COMPONENT STYLES
   ======================================== */

.search-bar {
  margin-bottom: var(--spacing-xl);
}

/* Search Container */
.search-container {
  position: relative;
  display: flex;
  align-items: center;
  background: var(--surface);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-md);
  border: 2px solid var(--border-color);
  transition: all 0.3s ease;
}

.search-container:focus-within {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
}

/* Search Icon */
.search-icon {
  padding: 0 var(--spacing-lg);
  color: var(--text-secondary);
  display: flex;
  align-items: center;
}

.search-icon i {
  font-size: 1.25rem;
}

/* Search Input */
.search-input {
  flex: 1;
  border: none;
  padding: 1rem var(--spacing-md);
  font-size: 1rem;
  background: transparent;
  outline: none;
  color: var(--text-primary);
}

.search-input::placeholder {
  color: var(--text-secondary);
}

/* Clear Button */
.clear-btn {
  padding: var(--spacing-md) var(--spacing-lg);
  background: transparent;
  border: none;
  color: var(--text-secondary);
  cursor: pointer;
  transition: color 0.2s ease;
  display: flex;
  align-items: center;
}

.clear-btn:hover {
  color: var(--danger-color);
}

.clear-btn i {
  font-size: 1.25rem;
}

/* Search Help Text */
.search-help {
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
  margin-top: var(--spacing-sm);
  padding: var(--spacing-md);
  background: var(--surface);
  border-radius: var(--radius-md);
  font-size: 0.875rem;
  color: var(--text-secondary);
  flex-wrap: wrap;
}

.search-help i {
  color: var(--primary-color);
}

.search-tip {
  margin-left: auto;
  font-weight: 500;
}

/* Keyboard key styling */
kbd {
  background: var(--background);
  border: 1px solid var(--border-color);
  border-radius: 3px;
  padding: 2px 6px;
  font-size: 0.75rem;
  font-family: monospace;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

/* Responsive Design */
@media (max-width: 768px) {
  .search-icon {
    padding: 0 var(--spacing-md);
  }
  
  .search-input {
    font-size: 0.875rem;
    padding: 0.875rem var(--spacing-sm);
  }
  
  .search-input::placeholder {
    font-size: 0.875rem;
  }
  
  .clear-btn {
    padding: var(--spacing-sm) var(--spacing-md);
  }
  
  .search-help {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .search-tip {
    margin-left: 0;
  }
}
</style>
