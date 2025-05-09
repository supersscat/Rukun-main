<template>
    <div class="p-4 md:p-5 h-fit max-h-full flex flex-col bg-white border shadow-sm rounded-xl space-y-4">
      <!-- Header -->
      <div>
        <h2 class="text-xl font-medium text-gray-800 w-full">Tambah Warga</h2>
      </div>
      <!-- End Header -->
  
      <hr>
  
      <div class="h-full w-full mt-2 overflow-y-auto">
        <form @submit.prevent="handleSubmit">
          <div class="space-y-4 flex flex-col">
            <!-- Nama Lengkap -->
            <div class="grid sm:grid-cols-3">
              <label for="full_name" class="block text-sm font-medium mb-2 w-full">Nama Lengkap</label>
              <div class="col-span-2">
                <input type="text" id="full_name" v-model="full_name"
                  class="py-3 px-4 block w-full border border-gray-200 rounded-lg text-sm focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none"
                  placeholder="John Doe">
                <small class="text-red-500 italic">{{ nameError }}</small>
              </div>
            </div>
            <!-- NIK -->
            <div class="grid sm:grid-cols-3">
              <label for="nik" class="block text-sm font-medium mb-2 w-full">Nomor Induk Kependudukan (NIK)</label>
              <div class="col-span-2">
                <input type="text" id="nik" v-model="nik" @input="handleNIKInput" maxlength="16"
                  class="py-3 px-4 block w-full border border-gray-200 rounded-lg text-sm focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none"
                  placeholder="xxxxxxxxxxxxxxxx">
                <small class="text-red-500 italic">{{ nikError }}</small>
              </div>
            </div>

            <!-- Jenis Kelamin -->
            <div class="grid sm:grid-cols-3">
              <label for="gender" class="block text-sm font-medium mb-2 w-full">Jenis Kelamin</label>
              <div class="col-span-2">
                <select id="gender"
                        v-model="gender"
                        class="py-3 px-4 block w-full border border-gray-200 rounded-lg text-sm focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none">
                  <option value="male">Laki-laki</option>
                  <option value="female">Perempuan</option>
                </select>
                <small class="text-red-500 italic">{{ genderError }}</small>
              </div>
            </div>

            <!-- Tanggal Lahir -->
            <div class="grid sm:grid-cols-3">
              <label for="dob" class="block text-sm font-medium mb-2 w-full">Tanggal Lahir</label>
              <div class="col-span-2">
                <input type="date" id="dob"
                      v-model="dob"
                      class="py-3 px-4 block w-full border border-gray-200 rounded-lg text-sm focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none">
                <small class="text-red-500 italic">{{ dobError }}</small>
              </div>
            </div>

            <!-- Alamat -->
            <div class="grid sm:grid-cols-3">
              <label for="address" class="block text-sm font-medium mb-2 w-full">Alamat</label>
              <div class="col-span-2">
                <textarea id="address"
                          v-model="address"
                          class="py-3 px-4 block w-full border border-gray-200 rounded-lg text-sm focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none"
                          placeholder="Jl. Raya 1234"></textarea>
                <small class="text-red-500 italic">{{ addError }}</small>
              </div>
            </div>

            <!-- KK Dropdown -->
            <div class="grid sm:grid-cols-3">
              <label for="kk_id" class="block text-sm font-medium mb-2 w-full">Kartu Keluarga (KK)</label>
              <div class="col-span-2">
                <ComboBoxKk class="w-full" @selectedKK="handleSelectKKID" />
                <small class="text-red-500 italic">{{ kkError }}</small>
              </div>
            </div>

  
            <div class="space-x-3 self-end">
              <button type="submit"
                      class="py-2 px-3 inline-flex items-center gap-x-2 text-sm font-medium rounded-lg border border-transparent bg-blue-600 text-white hover:bg-blue-700 focus:outline-none focus:bg-blue-700 disabled:opacity-50 disabled:pointer-events-none"
                      :disabled="isLoading">
                Simpan
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>
  </template>
  <script setup lang="ts">
  import ComboBoxKk from "~/components/form/advanced/ComboBoxKK.vue";
  import { useRouter } from "vue-router";
  
  const router = useRouter();
  
  const {$toast} = useNuxtApp();
  
  // State form
  const full_name = ref<string | null>(null);
  const nik = ref<string | null>(null); // NIK
  const gender = ref<string | null>(null);
  const dob = ref<string | null>(null);
  const address = ref<string | null>(null);
  const kk_id = ref<number | null>(null);
  const isLoading = ref<boolean>(false);
  const nikError = ref<string | null>(null);
  const nameError = ref<string | null>(null);
  const genderError = ref<string | null>(null);
  const dobError = ref<string | null>(null);
  const addError = ref<string | null>(null);
  const kkError = ref<string | null>(null);
  
  // Clear form state
  const clearForm = () => {
    full_name.value = null;
    nik.value = null;
    gender.value = null;
    dob.value = null;
    address.value = null;
    kk_id.value = null;
  };
  
  const handleSelectKKID = (e: any) => {
    kk_id.value = e.id;
  };
  
  const handleNIKInput = (event: Event) => {
    const input = (event.target as HTMLInputElement).value.replace(/\D/g, ''); // hapus non-digit
    nik.value = input.slice(0, 16); // batasi maksimal 16 digit
  };

  const checkKKAvailability = async () =>{
    nikError.value = null;
    nameError.value = null;
    genderError.value = null;
    dobError.value = null;
    addError.value = null;
    kkError.value = null;

  let valid = true;
// saya tahu ini aga efisien pak, wkwkwkw
  if (!full_name.value) {
    nameError.value = 'Nama lengkap harus diisi.';
    valid = false;
  }

  if (!nik.value || nik.value.length !== 16) {
    nikError.value = 'NIK harus terdiri dari 16 digit angka.';
    valid = false;
  }

  if (!gender.value) {
    genderError.value = 'Lengkapi semua data sebelum menyimpan.';
    valid = false;
  }
  if (!dob.value) {
    dobError.value = 'Lengkapi semua data sebelum menyimpan.';
    valid = false;
  }
  if (!address.value) {
    addError.value = 'Lengkapi semua data sebelum menyimpan.';
    valid = false;
  }
  if (!kk_id.value) {
    kkError.value ='Lengkapi semua data sebelum menyimpan.';
    return;
  }

  if (!valid) return false;
    try {
          console.log("Memulai pengecekan NIK:", nik.value);
          const result = await $fetch<{ nikTaken: boolean }>('/api/auth/checkCitizen', {
            method: 'post',
            body: { nik: nik.value }
          });
          console.log("Hasil check:", result);
          if (result.nikTaken) {
            nikError.value = 'NIK sudah terdaftar.';
            console.log("nik terdaftar")
          }

          return !result.nikTaken ;
        } catch (err) {
          nikError.value = 'Gagal memeriksa data NIK. Coba lagi.';
          return false;
      }
  }
  
    
  // Form submission handler
  const handleSubmit = async () => {
    const isAvailable = await checkKKAvailability();
    if (!isAvailable) return; 

    try {
      // Basic validation
      if (!full_name.value) {
        $toast('Nama lengkap harus diisi.', 'error');
        return;
      }
      if (!nik.value) {
        $toast('Nomer Induk Kependudukan (NIK) harus diisi.', 'error');
        return;
      }
      if (!nik.value || nik.value.length !== 16) {
      $toast('Nomer Induk Kependudukan (NIK) harus 16 digit angka.', 'error');
      return;
      }
      if (!gender.value) {
        $toast('Jenis Kelamin harus dipilih.', 'error');
        return;
      }
      if (!dob.value) {
        $toast('Tanggal Lahir harus diisi.', 'error');
        return;
      }
      if (!address.value) {
        $toast('Alamat harus diisi.', 'error');
        return;
      }
      if (!kk_id.value) {
        $toast('KK harus diisi.', 'error');
        return;
      }
  
      isLoading.value = true;
  
      // Transform data for API
      const payload = {
        full_name: full_name.value,
        nik: nik.value,
        gender: gender.value?.charAt(0).toUpperCase() + gender.value?.slice(1), // Capitalize first letter
        dob: dob.value,
        address: address.value,
        kk_id: kk_id.value,
      };
  
      // API call
      await useFetchApi('/api/auth/citizen', {
        method: 'POST',
        body: payload,
      });
  
      $toast('Data warga berhasil ditambahkan!', 'success');
      clearForm();
      router.push('/citizen');
    } catch (error) {
      $toast('Terjadi kesalahan pada server. Silakan coba lagi.', 'error');
    } finally {
      isLoading.value = false;
    }
  };
  </script>
  <style lang="css" scoped>
  </style>