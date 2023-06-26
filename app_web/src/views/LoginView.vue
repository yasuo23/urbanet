<template>
  <div class="home">
    <div class="login-container">
      <LoginForm />
    </div>
  </div>
</template>

<script>
import LoginForm from '../components/LoginForm'

export default {
  name: 'login',

  components: {
    LoginForm
  },
}
</script>

<style scoped>

.home {
  background-image: url(../assets/Background.jpg) !important;
  height: 100%;
  width: 100%;
  background-size: cover;
}

.login-container {
  margin-top: 50px;
  z-index: 2;
}

</style>