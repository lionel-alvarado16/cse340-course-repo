import bcrypt from 'bcrypt';
import { createUser, getAllUsers, authenticateUser, addVolunteerToProject, removeVolunteerFromProject } from '../models/users.js';
import { getProjectsByUserId } from '../models/projects.js';

const showUserRegistrationForm = async (req, res) => {
    res.render('register', { title: 'Register' });
};

const processUserRegistrationForm = async (req, res) => {
    const { name, email, password } = req.body;

    try {
        // Hash the password before storing it
        const salt = await bcrypt.genSalt(10);
        const passwordHash = await bcrypt.hash(password, salt);

        // Create the user in the database
        const userId = await createUser(name, email, passwordHash);

        // Redirect to the home page after successful registration
        req.flash('success', 'Registration successful! Please log in.');
        res.redirect('/');
    } catch (error) {
        console.error('Error registering user:', error);
        req.flash('error', 'An error occurred during registration. Please try again.');
        res.redirect('/register');
    }
};

const showLoginForm = async (req, res) => {
    res.render('login', { title: 'Login' });
};

const processLoginForm = async (req, res) => {
    const { email, password } = req.body;

    try {
        const user = await authenticateUser(email, password);
        if (user) {
            // Store user info in session
            req.session.user = user;
            req.flash('success', 'Login successful!');

            if (res.locals.NODE_ENV === 'development') {
                console.log('User logged in:', user);
            }

            res.redirect('/dashboard');
        } else {
            req.flash('error', 'Invalid email or password.');
            res.redirect('/login');
        }
    } catch (error) {
        console.error('Error during login:', error);
        req.flash('error', 'An error occurred during login. Please try again.');
        res.redirect('/login');
    }
};

const processLogout = async (req, res) => {
    if (req.session.user) {
        delete req.session.user;
    }

    req.flash('success', 'Logout successful!');
    res.redirect('/login');
};

const requireLogin = (req, res, next) => {
    if (!req.session || !req.session.user) {
        req.flash('error', 'You must be logged in to access that page.');
        return res.redirect('/login');
    }

    next();
};

const showDashboard = async (req, res) => {
    try {
        const user = req.session.user;

        const volunteerProjects = await getProjectsByUserId(user.user_id);

        res.render('dashboard', {
            title: 'Dashboard',
            name: user.name,
            email: user.email,
            volunteerProjects
        });
    } catch (error) {
        console.error('Error loading dashboard:', error);
        req.flash('error', 'Could not load your dashboard projects.');
        res.render('dashboard', {
            title: 'Dashboard',
            name: req.session.user.name,
            email: req.session.user.email,
            volunteerProjects: []
        });
    }
};

/**
 * Middleware factory to require specific role for route access
 * Returns middleware that checks if user has the required role
 * 
 * @param {string} role - The role name required (e.g., 'admin', 'user')
 * @returns {Function} Express middleware function
 */
const requireRole = (role, redirectTo = '/') => {
    return (req, res, next) => {
        // Check if user is logged in first
        if (!req.session || !req.session.user) {
            req.flash('error', 'You must be logged in to access this page.');
            return res.redirect('/login');
        }

        // Check if user's role matches the required role
        if (req.session.user.role_name !== role) {
            req.flash('error', 'You do not have permission to access this page.');
            return res.redirect(redirectTo);
        }

        // User has required role, continue
        next();
    };
};

const showUsersList = async (req, res) => {
    const users = await getAllUsers();
    const title = 'Users Page';

    res.render('users', { title, users });
};

const processAddVolunteer = async (req, res) => {
    try {
        const projectId = req.params.id;
        const user = req.session.user;

        if (!user) {
            req.flash('error', 'You must be logged in to volunteer.');
            return res.redirect('/login');
        }

        await addVolunteerToProject(user.user_id, projectId);
        req.flash('success', 'Volunteer added to the project successfully.');
        res.redirect(`/project/${projectId}`);
    } catch (error) {
        console.error('Error adding volunteer:', error);
        req.flash('error', 'Could not add volunteer to the project.');
        res.redirect(`/project/${req.params.id}`);
    }
};

const processRemoveVolunteer = async (req, res) => {
    try {
        const projectId = req.params.id;
        const user = req.session.user;

        if (!user) {
            req.flash('error', 'You must be logged in.');
            return res.redirect('/login');
        }

        await removeVolunteerFromProject(user.user_id, projectId);
        req.flash('success', 'Volunteer removed from the project successfully.');
        res.redirect(`/project/${projectId}`);
    } catch (error) {
        console.error('Error removing volunteer:', error);
        req.flash('error', 'Could not remove volunteer from the project.');
        res.redirect(`/project/${req.params.id}`);
    }
};

const processRemoveVolunteerFromDashboard = async (req, res) => {
    try {
        const projectId = req.params.id;
        const user = req.session.user;

        await removeVolunteerFromProject(user.user_id, projectId);
        req.flash('success', 'You have been removed as a volunteer from the project.');
        res.redirect('/dashboard');
    } catch (error) {
        console.error('Error removing volunteer:', error);
        req.flash('error', 'Could not remove volunteer.');
        res.redirect('/dashboard');
    }
};

export {
    showUserRegistrationForm,
    processUserRegistrationForm,
    showLoginForm,
    processLoginForm,
    processLogout,
    requireLogin,
    showDashboard,
    requireRole,
    showUsersList,
    processAddVolunteer,
    processRemoveVolunteer,
    processRemoveVolunteerFromDashboard
};