<template>
    <div id="hs-application-sidebar" class="hs-overlay [--auto-close:lg]
      hs-overlay-open:translate-x-0
      -translate-x-full transition-all duration-300 transform
      w-[260px] h-full
      hidden
      fixed inset-y-0 start-0 z-[60]
      bg-white border-e border-gray-200
      lg:block lg:translate-x-0 lg:end-auto lg:bottom-0" role="dialog" tabindex="-1" aria-label="Sidebar">
      <div class="relative flex flex-col h-full max-h-full">
        <div class="px-6 pt-4">
          <!-- Logo -->
          <AppLogo/>
          <!-- End Logo -->
        </div>
  
        <!-- Content -->
        <div class="h-full overflow-y-auto [&::-webkit-scrollbar]:w-2 [&::-webkit-scrollbar-thumb]:rounded-full [&::-webkit-scrollbar-track]:bg-gray-100 [&::-webkit-scrollbar-thumb]:bg-gray-300">
          <nav class="hs-accordion-group p-3 w-full flex flex-col flex-wrap" data-hs-accordion-always-open>
            <ul class="flex flex-col space-y-1">
              <li>
                <NuxtLink
                    class="flex items-center gap-x-3.5 py-2 px-2.5 text-sm text-gray-800 rounded-lg hover:bg-gray-100 focus:outline-none focus:bg-gray-100"
                    to="/" active-class="bg-gray-100">
                  <svg class="shrink-0 size-4" xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                       viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                       stroke-linejoin="round">
                    <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                    <polyline points="9 22 9 12 15 12 15 22"/>
                  </svg>
                  Beranda
                </NuxtLink>
              </li>
              
              <!-- More menu items here -->
              
              <li style="position: absolute; bottom: 80px; width: 90%;">
                <button
                    class="w-full flex items-center gap-x-3.5 py-2 px-2.5 text-sm text-gray-800 rounded-lg hover:bg-gray-100 focus:outline-none focus:bg-gray-100"
                    @click="handleLogout">
                  <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path
                        d="M8 16H5.33333C4.97971 16 4.64057 15.8595 4.39052 15.6095C4.14048 15.3594 4 15.0203 4 14.6667V5.33333C4 4.97971 4.14048 4.64057 4.39052 4.39052C4.64057 4.14048 4.97971 4 5.33333 4H8"
                        stroke="#2B2B2B" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M12.6666 13.3332L16 9.99984L12.6666 6.6665" stroke="#2B2B2B" stroke-width="1.5"
                          stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                  Keluar
                </button>
              </li>
            </ul>
          </nav>
        </div>
        <!-- End Content -->
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import AppLogo from "~/components/AppLogo.vue";
  
  const userRole = useCookie('user_role').value;
  const { logout } = useAuth();
  const { $toast } = useNuxtApp();
  
  const handleLogout = async () => {
    try {
      await logout()
    } catch (error: any) {
      return
    } finally {
      $toast('Berhasil menghapus sesi masuk.', 'success');
      navigateTo('/auth/login');
    }
  }
  </script>