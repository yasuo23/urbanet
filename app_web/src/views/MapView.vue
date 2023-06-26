<template>
    <div class="flexed-page">
        <div class="slider-container">
            <AppSlideBar />
        </div>
        <div class="main-content">
            <AppNavBar title="MAP" />
            <MapComponent/>
        </div>
    </div>
</template>

<script>
import AppSlideBar from "../components/AppSlideBar";
import AppNavBar from "../components/AppNavBar.vue";
import MapComponent from "../components/MapComponent.vue";

export default {
    name: "dashboard",

    components: {
        AppSlideBar,
        AppNavBar,
        MapComponent
    },
};
</script>

<style scoped>
.flexed-page {
  height: 100%;
  display: flex;
}

.slider-container {
  height: 100%;
}

.main-content {
  width: 100%;
  height: 100%;
}
</style>