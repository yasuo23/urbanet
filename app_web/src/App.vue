<template>
  <v-app>
    <router-view class="background"/>
  </v-app>
</template>

<script>
export default {
  name: 'App',

  data: () => ({
    //
  }),
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css?family=Roboto+Condensed');

body {
  font-family: 'Roboto', sans-serif;
}


#app {
  font-family: 'Roboto', sans-serif;
}
.v-application {
  font-family: 'Roboto', sans-serif;
}
.v-main {
  align-items: center;
}
.v-main__wrap {
  height: 100% !important;
}
</style>