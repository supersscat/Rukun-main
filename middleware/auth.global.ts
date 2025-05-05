export default defineNuxtRouteMiddleware((to, from) => {
  const isAuthenticated = useCookie('isLoggedIn').value;
  const userRole = useCookie('user_role').value ?? 'User';

  const publicPages = [
    '/auth/login',
    '/auth/register',
    '/auth/forget-password',
    '/auth/reset-password',
    '/auth/verification'
  ];

  const isPublicPage = publicPages.includes(to.path);

  if (!isPublicPage && !isAuthenticated) {
    return navigateTo('/auth/login', { redirectCode: 302 });
  }

  const isAuthPage = publicPages.includes(to.path);
  if (isAuthPage && isAuthenticated) {
    return navigateTo(userRole === 'Admin' ? '/admin/dashboard' : '/user/dashboard');
  }

  if (userRole === 'Admin' && to.path.startsWith('/user')) {
    return navigateTo('/admin/dashboard');
  }

  if (userRole === 'User' && to.path.startsWith('/admin')) {
    return navigateTo('/user/dashboard');
  }
});
