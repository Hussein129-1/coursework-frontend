# 🎓 After School Classes - Frontend Application

> A modern Vue.js 3 application for browsing and booking after-school classes

[![Vue.js](https://img.shields.io/badge/Vue.js-3.5-green.svg)](https://vuejs.org/)
[![Vite](https://img.shields.io/badge/Vite-5.0-purple.svg)](https://vitejs.dev/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## �� Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Screenshots](#screenshots)
- [Tech Stack](#tech-stack)
- [Installation](#installation)
- [Usage](#usage)
- [Components](#components)
- [API Integration](#api-integration)
- [Deployment](#deployment)
- [Project Structure](#project-structure)

## 🌟 Overview

A beautiful, responsive single-page application (SPA) built with Vue.js 3 for managing after-school class bookings. Students can browse available classes, search for specific subjects, add classes to their cart, and complete the checkout process with form validation.

**Live Demo**: [https://hussein129-1.github.io/coursework-frontend/](https://hussein129-1.github.io/coursework-frontend/)

## ✨ Features

### Core Functionality
- ✅ **Browse 15 Lessons** - View all available after-school classes
- ✅ **Advanced Sorting** - Sort by subject, location, price, or available spaces (ascending/descending)
- ✅ **Real-time Search** - Search as you type across all lesson attributes
- ✅ **Shopping Cart** - Add/remove lessons with instant updates
- ✅ **Space Management** - Automatic inventory tracking and updates
- ✅ **Form Validation** - Regex-based validation (letters-only name, numbers-only phone)
- ✅ **Order Confirmation** - Submit orders to backend API
- ✅ **Responsive Design** - Works seamlessly on desktop, tablet, and mobile

### UI/UX Features
- 🎨 **Modern Design** - Clean, professional interface
- 🎭 **Icon-Based Cards** - Beautiful Font Awesome icons for each subject
- ⚡ **Enhanced Loader** - Animated spinner with pulsing effects
- 🛒 **Cart Badge** - Real-time cart item count
- 📱 **Mobile Responsive** - Optimized for all screen sizes
- 🎯 **Intuitive Navigation** - Easy toggle between lessons and cart views

## 🛠️ Tech Stack

| Technology | Purpose | Version |
|------------|---------|---------|
| **Vue.js 3** | Frontend framework | 3.5.22 |
| **Vite** | Build tool & dev server | 5.x |
| **JavaScript (ES6+)** | Programming language | - |
| **CSS3** | Styling | - |
| **Font Awesome** | Icons | 6.4.0 |
| **Fetch API** | HTTP requests | Native |

## 🚀 Installation

### Prerequisites
- Node.js 18 or higher
- npm or yarn
- Git

### Steps

1. **Clone the repository**
```bash
git clone https://github.com/Hussein129-1/coursework-frontend.git
cd coursework-frontend
```

2. **Install dependencies**
```bash
npm install
```

3. **Configure environment**

Create `.env.development` for local development:
```env
VITE_API_BASE_URL=http://localhost:3000
```

Create `.env.production` for production:
```env
VITE_API_BASE_URL=https://hussein-coursework-backend.onrender.com
```

4. **Start development server**
```bash
npm run dev
```

Application will be available at `http://localhost:5173`

## 📖 Usage

### Development Mode
```bash
npm run dev
```
Runs the app in development mode with hot module replacement (HMR).

### Build for Production
```bash
npm run build
```
Builds the app for production to the `dist/` folder.

### Preview Production Build
```bash
npm run preview
```
Locally preview the production build.

### Deploy to GitHub Pages
```bash
npm run deploy
```
Automatically builds and deploys to GitHub Pages.

## 🧩 Components

### App.vue
Main application component that orchestrates all functionality:
- State management (lessons, cart, search)
- API communication
- View toggling (lessons vs cart)

### LessonList.vue
Displays the grid of lesson cards with sorting functionality:
- Receives lessons array as prop
- Emits sort change events
- Renders LessonCard components

### LessonCard.vue
Individual lesson card showing:
- Subject icon (Font Awesome)
- Subject name and description
- Location, price, available spaces
- Add to cart button (disabled when sold out)

### SearchBar.vue
Search input component:
- Real-time search as you type
- Emits search events to parent
- Shows search icon and clear button

### ShoppingCart.vue
Shopping cart display:
- Lists all cart items
- Remove item functionality
- Shows total price and spaces
- Checkout button

### CheckoutForm.vue
Order submission form with validation:
- Customer name input (letters and spaces only)
- Phone number input (digits only)
- Real-time validation with error messages
- Submit button with loading state

## 🔌 API Integration

### Backend Endpoints Used

```javascript
// config.js
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3000';

const API_ENDPOINTS = {
  lessons: `${API_BASE_URL}/lessons`,
  search: `${API_BASE_URL}/search`,
  order: `${API_BASE_URL}/order`,
  updateLesson: (lessonId) => `${API_BASE_URL}/lessons/${lessonId}`
};
```

### API Calls

**Fetch all lessons:**
```javascript
const response = await fetch(API_ENDPOINTS.lessons);
const lessons = await response.json();
```

**Search lessons:**
```javascript
const response = await fetch(`${API_ENDPOINTS.search}?q=${query}`);
const results = await response.json();
```

**Create order:**
```javascript
const response = await fetch(API_ENDPOINTS.order, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(orderData)
});
```

**Update lesson spaces:**
```javascript
const response = await fetch(API_ENDPOINTS.updateLesson(lessonId), {
  method: 'PUT',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ spaces: newSpaces })
});
```

## 📦 Project Structure

```
frontend-repo/
├── public/
│   └── vite.svg              # Favicon
├── src/
│   ├── assets/               # Static assets
│   ├── components/
│   │   ├── LessonList.vue    # Lesson grid display
│   │   ├── LessonCard.vue    # Individual lesson card
│   │   ├── SearchBar.vue     # Search input
│   │   ├── ShoppingCart.vue  # Cart display
│   │   └── CheckoutForm.vue  # Checkout form
│   ├── App.vue               # Root component
│   ├── config.js             # API configuration
│   ├── main.js               # App entry point
│   └── style.css             # Global styles
├── scripts/
│   ├── deploy.sh             # Deployment script
│   └── git-multi-commit.sh   # Commit automation
├── .env.development          # Dev environment
├── .env.production           # Prod environment
├── index.html                # HTML entry
├── vite.config.js            # Vite config
├── package.json              # Dependencies
└── README.md                 # This file
```

## 🚢 Deployment

### GitHub Pages Deployment

1. **Build the application**
```bash
npm run build
```

2. **Deploy using the automated script**
```bash
npm run deploy
```

This script:
- Builds the production bundle
- Copies assets to repository root
- Commits and pushes to `gh-pages` branch
- Makes the app accessible via GitHub Pages

### Manual Deployment

```bash
# Install gh-pages package
npm install -g gh-pages

# Build and deploy
npm run build
gh-pages -d dist
```

## 🎨 Design Features

### Color Scheme
```css
--primary-color: #4F46E5;        /* Indigo */
--primary-hover: #4338CA;        /* Dark indigo */
--success-color: #10B981;        /* Green */
--danger-color: #EF4444;         /* Red */
--background: #F9FAFB;           /* Light gray */
```

### Responsive Breakpoints
- Desktop: > 1024px
- Tablet: 768px - 1024px
- Mobile: < 768px

## ✅ Form Validation

### Name Field
- **Rule**: Letters and spaces only
- **Regex**: `/^[A-Za-z\s]+$/`
- **Min Length**: 2 characters

### Phone Field
- **Rule**: Numbers only
- **Regex**: `/^[0-9]+$/`
- **Min Length**: 10 digits
- **Max Length**: 15 digits

## 🧪 Testing

### Manual Testing Checklist
- [ ] All 15 lessons display correctly
- [ ] Sorting works for all attributes (asc/desc)
- [ ] Search returns relevant results
- [ ] Add to cart decrements available spaces
- [ ] Remove from cart restores spaces
- [ ] Cart badge updates in real-time
- [ ] Checkout validation works (name/phone)
- [ ] Order submission succeeds
- [ ] Responsive on mobile devices

## 📝 Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server |
| `npm run build` | Build for production |
| `npm run preview` | Preview production build |
| `npm run deploy` | Deploy to GitHub Pages |
| `npm run autocommit` | Create multiple git commits |

## 🔧 Configuration

### Vite Configuration
```javascript
// vite.config.js
export default {
  base: '/coursework-frontend/',  // GitHub Pages base path
  server: {
    port: 5173
  }
}
```

### Environment Variables
All environment variables must be prefixed with `VITE_` to be exposed to the client:
```
VITE_API_BASE_URL=http://localhost:3000
```

## 🐛 Troubleshooting

### Port Already in Use
```bash
# Kill process on port 5173
lsof -ti:5173 | xargs kill -9
```

### API Connection Issues
- Verify backend server is running
- Check CORS is enabled on backend
- Confirm API_BASE_URL in `.env` file

### Build Errors
```bash
# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

## 📄 License

MIT License - Educational Project

## 👤 Author

- **GitHub**: [@Hussein129-1](https://github.com/Hussein129-1)
- **Repository**: [coursework-frontend](https://github.com/Hussein129-1/coursework-frontend)

## 🙏 Acknowledgments

- Vue.js 3 Documentation
- Vite Documentation
- Font Awesome for icons
- CST3144 Full Stack Development Course

---

**Last Updated**: November 2024  
**Version**: 1.0.0
