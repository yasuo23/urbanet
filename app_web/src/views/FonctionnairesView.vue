<template>
    <div class="flexed-page">
        <div class="slider-container">
            <AppSlideBar />
        </div>
        <div class="main-content">
            <AppNavBar title="Fonctinnaires" />
            <div class="body">
                <WorkersData />
            </div>
        </div>
    </div>
</template>

<script>
import AppSlideBar from "../components/AppSlideBar";
import AppNavBar from "../components/AppNavBar.vue";
import WorkersData from "../components/WorkersData.vue";

export default {
    name: "utilisateurs",

    components: {
        AppSlideBar,
        AppNavBar,
        WorkersData
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

.body {
    margin: 40px 20px;
}
</style>