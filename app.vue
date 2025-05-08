<template>
  <div>
    <NuxtLayout>
      <NuxtLoadingIndicator color="#f38302" />
      <NuxtPage />
    </NuxtLayout>
  </div>
</template>

<script lang="ts" setup>
const {initAuth} = useAuth()

onMounted(() => {
  initAuth()
})
</script>