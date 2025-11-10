# After School Classes - Booking System

A full-stack web application for booking after-school classes and activities, built with Vue.js and Express.js.

## 📋 Project Overview

This coursework project demonstrates a complete full-stack application with:
- **Frontend:** Vue.js 3 with Composition API
- **Backend:** Express.js REST API
- **Database:** MongoDB Atlas
- **Features:** Lesson browsing, sorting, search, shopping cart, and checkout

## 🔗 Important Links

### Frontend (Vue.js App)
- **GitHub Repository:** [Add your frontend GitHub repo URL]
- **GitHub Pages (Live Demo):** [Add your GitHub Pages URL]

### Backend (Express.js App)
- **GitHub Repository:** [Add your backend GitHub repo URL]
- **Deployed API (AWS/Render):** [Add your deployed backend URL]
- **Test Endpoint:** `[Your-Backend-URL]/lessons`

## 🚀 Quick Start

### Frontend Setup

1. Install dependencies:
```bash
npm install
```

2. Start development server:
```bash
npm run dev
```

3. Build for production:
```bash
npm run build
```

The frontend will be available at `http://localhost:5173`

### Backend Setup

1. Navigate to backend folder:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Configure MongoDB connection in `server.js`

4. Initialize database:
```bash
node init-database.js
```

5. Start server:
```bash
npm start
```

The backend API will run at `http://localhost:3000`

## 📁 Project Structure

```
hussein_coursework/
├── src/                          # Frontend source code
│   ├── components/              # Vue components
│   │   ├── LessonCard.vue      # Individual lesson display
│   │   ├── LessonList.vue      # Lessons grid with sorting
│   │   ├── ShoppingCart.vue    # Shopping cart display
│   │   ├── CheckoutForm.vue    # Checkout form with validation
│   │   └── SearchBar.vue       # Search functionality
│   ├── App.vue                  # Main application component
│   ├── main.js                  # Vue app entry point
│   ├── style.css                # Global styles
│   └── config.js                # API configuration
├── backend/                      # Backend source code
│   ├── server.js                # Express server with REST API
│   ├── init-database.js         # Database setup script
│   ├── package.json             # Backend dependencies
│   └── public/images/           # Static lesson images
├── index.html                    # HTML template
├── package.json                  # Frontend dependencies
└── README.md                     # This file
```

## ✨ Key Features

### Frontend Features
- ✅ Display list of 10+ lessons with all details
- ✅ Sort by subject, location, price, or spaces
- ✅ Ascending/descending sort order
- ✅ Add to cart functionality with space management
- ✅ Shopping cart with item management
- ✅ Form validation (name: letters only, phone: numbers only)
- ✅ Full-text search with "search as you type"
- ✅ Responsive design for all screen sizes

### Backend Features
- ✅ REST API with Express.js
- ✅ MongoDB Atlas integration
- ✅ Logger middleware for request tracking
- ✅ Static file serving for images
- ✅ GET /lessons - Retrieve all lessons
- ✅ GET /search - Search lessons
- ✅ POST /order - Create new order
- ✅ PUT /lessons/:id - Update lesson spaces

## 🎓 For Beginners

This project is structured for easy understanding:

1. **Separated Components:** Each feature is in its own component file
2. **Detailed Comments:** Every function and section is explained
3. **Clear Structure:** Organized folders and naming conventions
4. **Step-by-Step Logic:** Code flows logically with explanations

### Learning Resources
- Read `DOCUMENTATION_PROJECT_STRUCTURE.txt` for architecture overview
- Read `DOCUMENTATION_HOW_TO_NAVIGATE.txt` for code walkthrough
- Read `DOCUMENTATION_DEMO_STEPS.txt` for demonstration guide
- Read `DOCUMENTATION_BACKEND_EXPLAINED.txt` for backend details

## 🧪 Testing

### Test with Postman
1. Import the Postman collection (included in submission)
2. Test all API endpoints
3. Verify responses and data flow

### Manual Testing
1. Browse lessons and verify sorting works
2. Add items to cart and check space decreases
3. Remove items and verify space increases
4. Test form validation with invalid inputs
5. Submit order and verify database updates
6. Search for lessons and verify results

## 📦 Submission Contents

- Frontend code (Vue.js)
- Backend code (Express.js)
- MongoDB collections export (lessons, orders)
- Postman collection with API requests
- Documentation files
- README with all required links

## 🛠️ Technologies Used

- **Vue.js 3:** Progressive JavaScript framework
- **Vite:** Fast build tool and dev server
- **Express.js:** Backend web framework
- **MongoDB:** NoSQL database
- **Font Awesome:** Icon library
- **Native Fetch API:** HTTP requests (no axios)

## 📝 Requirements Met

- ✅ Vue.js framework (no other frameworks)
- ✅ Node.js backend (not Apache/XAMPP)
- ✅ Express.js REST API
- ✅ MongoDB Atlas (not local database)
- ✅ Native fetch() (no XMLHttpRequest/axios)
- ✅ 10+ commits on GitHub
- ✅ Deployed on GitHub Pages
- ✅ Backend on AWS/Render.com
- ✅ All functional requirements implemented

## 👨‍💻 Development Notes

This project follows best practices:
- Component-based architecture
- Reactive state management
- Promise-based async operations
- Error handling and loading states
- Responsive CSS design
- Accessibility considerations

## 📄 License

This is a coursework project for educational purposes.

---

**Student Project - Full Stack Development 2024-25**
