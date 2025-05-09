<template>
  <div class="p-4 md:p-5 h-fit max-h-full flex flex-col bg-white border shadow-sm rounded-xl space-y-4">
    <div>
      <h2 class="text-xl font-medium text-gray-800 w-full">Ubah Data Warga</h2>
    </div>
    <hr />
    <div class="h-full w-full mt-2">
      <form v-if="selectedCitizen" @submit.prevent="handleSubmit">
        <div class="space-y-4 flex flex-col">

          <!-- Nama Lengkap -->
          <div class="grid grid-cols-3">
            <label for="full_name" class="block text-sm font-medium mb-2 w-full">Nama Lengkap</label>
            <div class="col-span-2">
              <input type="text" id="full_name" v-model="selectedCitizen.full_name"
                class="py-3 px-4 block w-full border border-gray-300 rounded-lg text-sm focus:border-blue-500 focus:ring-blue-500"
                placeholder="Nama Lengkap" />
              <small class="text-red-500 italic">{{ nameError }}</small>
            </div>
          </div>

          <!-- NIK -->
          <div class="grid grid-cols-3">
            <label for="nik" class="block text-sm font-medium mb-2 w-full">NIK</label>
            <div class="col-span-2">
              <input type="text" id="nik" maxlength="16" @input="handleNIKInput"
                v-model="selectedCitizen.nik"
                class="py-3 px-4 block w-full border border-gray-300 rounded-lg text-sm focus:border-blue-500 focus:ring-blue-500"
                placeholder="Nomor Induk Kependudukan" />
              <small class="text-red-500 italic">{{ nikError }}</small>
            </div>
          </div>

          <!-- Tanggal Lahir -->
          <div class="grid grid-cols-3">
            <label for="dob" class="block text-sm font-medium mb-2 w-full">Tanggal Lahir</label>
            <div class="col-span-2">
              <input type="date" id="dob" v-model="selectedCitizen.dob"
                class="py-3 px-4 block w-full border border-gray-300 rounded-lg text-sm focus:border-blue-500 focus:ring-blue-500" />
              <small class="text-red-500 italic">{{ dobError }}</small>
            </div>
          </div>

          <!-- Jenis Kelamin -->
          <div class="grid grid-cols-3">
            <label for="gender" class="block text-sm font-medium mb-2 w-full">Jenis Kelamin</label>
            <div class="col-span-2">
              <select id="gender" v-model="selectedCitizen.gender"
                class="py-3 px-4 block w-full border border-gray-300 rounded-lg text-sm focus:border-blue-500 focus:ring-blue-500">
                <option value="">-- Pilih --</option>
                <option value="Male">Laki-laki</option>
                <option value="Female">Perempuan</option>
              </select>
              <small class="text-red-500 italic">{{ genderError }}</small>
            </div>
          </div>

          <!-- Alamat -->
          <div class="grid grid-cols-3">
            <label for="address" class="block text-sm font-medium mb-2 w-full">Alamat</label>
            <div class="col-span-2">
              <textarea id="address" v-model="selectedCitizen.address"
                class="py-3 px-4 block w-full border border-gray-300 rounded-lg text-sm focus:border-blue-500 focus:ring-blue-500"
                placeholder="Alamat lengkap"></textarea>
              <small class="text-red-500 italic">{{ addressError }}</small>
            </div>
          </div>

          <!-- Tombol -->
          <div class="space-x-3 self-end">
            <button type="button" @click="cancel"
              class="py-2 px-3 text-sm font-medium rounded-lg border border-red-600 text-red-600 hover:bg-red-200">
              Batal
            </button>
            <button type="submit"
              class="py-2 px-3 text-sm font-medium rounded-lg border bg-blue-600 text-white hover:bg-blue-700"
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
  import type {Citizen} from "~/types/TypesModel";
  import useFetchApi from '~/composables/useFetchApi';
  import {useRouter} from "vue-router";
  
  const router = useRouter();
  const {$toast} = useNuxtApp();
  
  const route = useRoute();
  const citizenId = parseInt(route.params.id as string, 10);
  
  const selectedCitizen = ref<Citizen | null>(null); 
  const nik = ref<string | null>(null); // NIK 
  const isLoading = ref(false);
  const nameError = ref<string | null>(null);
  const nikError = ref<string | null>(null);
  const dobError = ref<string | null>(null);
  const genderError = ref<string | null>(null);
  const addressError = ref<string | null>(null);

  
  onMounted(async () => {
    fetchCitizenData();
  });

  const handleNIKInput = (event: Event) => {
    const input = (event.target as HTMLInputElement).value.replace(/\D/g, ''); // hapus non-digit
    nik.value = input.slice(0, 16); // batasi maksimal 16 digit
  };
    
  
  
  async function fetchCitizenData() {
    isLoading.value = true;
    try {
      const {data} = await useFetchApi(`/api/auth/citizen/${citizenId}`, {
        method: "GET",
      }) as { data: Citizen };
      selectedCitizen.value = {
        id: data.id,
        full_name: data.full_name,
        dob: data.dob?.slice(0, 10),
        gender: data.gender,
        address: data.address,
        kk_id: data.kk_id,
        nik: data.nik,
      };
    } catch (error) {
      $toast("Gagal mengambil data Warga.", "error");
    } finally {
      isLoading.value = false;
    }
  }

  const checkKKAvailability = async () =>{
    nikError.value = null;
    nameError.value = null;
    genderError.value = null;

    let valid = true;

    if (!selectedCitizen.value?.full_name) {
      nameError.value = 'Nama lengkap harus diisi.';
      valid = false;
    }

    if (!selectedCitizen.value?.nik || selectedCitizen.value.nik.length !== 16) {
      nikError.value = 'NIK harus terdiri dari 16 digit angka.';
      valid = false;
    }

    if (
      !selectedCitizen.value?.gender ||
      !selectedCitizen.value?.dob ||
      !selectedCitizen.value?.address
    ) {
      genderError.value = 'Lengkapi semua data sebelum menyimpan.';
      return;
    }

    if (!valid) return false;
    try {
          console.log("Memulai pengecekan NIK:", selectedCitizen.value.nik);
          const result = await $fetch<{ nikTaken: boolean }>('/api/auth/checkCitizen', {
            method: 'post',
            body: { nik: selectedCitizen.value.nik }
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
  
  const handleSubmit = async () => {
    if (!selectedCitizen.value) return;

    const isAvailable = await checkKKAvailability();
    if (!isAvailable) return; 
  
    isLoading.value = true;
    try {
      await useFetchApi(`/api/auth/citizen/${selectedCitizen.value.id}`, {
        method: "PUT",
        body: selectedCitizen.value,
      });
      $toast("Berhasil mengubah data Warga.", "success");
      router.push("/citizen");
    } catch (error) {
      $toast("Gagal mengubah data Warga.", "error");
    } 
    finally {
      isLoading.value = false;
    }
  };
  
  const cancel = () => {
    router.push('/citizen');
  };
  </script>
  
  <style scoped></style>