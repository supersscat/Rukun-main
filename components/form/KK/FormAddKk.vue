<template>
  <div class="p-4 md:p-5 h-fit max-h-full flex flex-col bg-white border shadow-sm rounded-xl space-y-4">
    <!-- Header -->
    <div>
      <h2 class="text-xl font-medium text-gray-800 w-full">Tambah Data Kartu Keluarga</h2>
    </div>
    <!-- End Header -->

    <hr>

    <div class="h-full w-full mt-2">
      <form @submit.prevent="handleSubmit">
        <div class="space-y-4 flex flex-col">

          <!-- Nomor Kartu Keluarga (KK) -->
          <div class="grid sm:grid-cols-3">
            <label for="kk" class="block text-sm font-medium mb-2 w-full">Nomor Keluarga (KK)</label>
            <div class="col-span-2">
              <input
                type="text"
                id="kk"
                v-model="kk"
                @input="handleKKInput"
                maxlength="16"
                class="py-3 px-4 block w-full border border-gray-200 rounded-lg text-sm focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none"
                placeholder="1234567890123456"
              />
              <small class="text-red-500 italic">{{ kkError }}</small>
            </div>
          </div>

          <!-- Nama Kepala Keluarga --> 
          <div class="grid sm:grid-cols-3">
            <label for="name" class="block text-sm font-medium mb-2 w-full">Nama Kepala Keluarga</label>
            <div class="col-span-2">
              <input
                type="text"
                id="name"
                v-model="name"
                class="py-3 px-4 block w-full border border-gray-200 rounded-lg text-sm focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none"
                placeholder="Muhammad"
              />
              <small class="text-red-500 italic">{{ nameError }}</small> <!-- ⬅️ pindah ke sini -->
            </div>
          </div>


          <!-- Submit Button -->
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
import useFetchApi from '~/composables/useFetchApi';
import { useRouter } from "vue-router";

const router = useRouter();

const { $toast } = useNuxtApp();

const name = ref<string | null>(null);
const kk = ref<string | null>(null);
const isLoading = ref<boolean>(false);
const kkError = ref<string | null>(null);
const nameError = ref<string | null>(null);


const clearForm = () => {
  name.value = null;
  kk.value = null; 
};

const handleKKInput = (event: Event) => {
  const input = (event.target as HTMLInputElement).value.replace(/\D/g, ''); // hapus non-digit
  kk.value = input.slice(0, 16); // batasi maksimal 16 digit
};

//Check KK double atau ga
const checkKKAvailability = async () => {
  // Reset error state
  kkError.value = null;
  nameError.value = null;

  let valid = true;
  if (!name.value) {
      nameError.value = 'Nama kepala keluarga wajib diisi.';
      valid = false;
    }
  if (!kk.value || kk.value.length !== 16)  {
      kkError.value = 'Nomor Kartu Keluarga harus terdiri dari 16 digit angka.';
      valid = false;
    }
  if (!valid) return false;
  

  try {
    const result = await $fetch<{ kkTaken: boolean }>('/api/auth/checkKK', {
      method: 'post',
      body: { kk: kk.value }
    });

    if (result.kkTaken) {
      kkError.value = 'Nomor KK sudah terdaftar.';
    }

    return !result.kkTaken ;
  } catch (err) {
    kkError.value = 'Gagal memeriksa data KK. Coba lagi.';
    return false;
  }
};


// Form submission handler
const handleSubmit = async () => {
  const isAvailable = await checkKKAvailability();
  if (!isAvailable) return; 
    
  try {

    isLoading.value = true;

    // Transform data for API
    const payload = {
      head_of_family: name.value,
      kk: kk.value,
    };

    // API call
    await useFetchApi('/api/auth/kk', {
      method: 'POST',
      body: payload,
    });

    $toast('Data KK berhasil ditambahkan!', 'success');
    clearForm();
    router.push('/kk');
  } catch (error) {
    $toast('Terjadi kesalahan pada server. Silakan coba lagi.', 'error');
  } finally {
    isLoading.value = false;
  }
};
</script>
