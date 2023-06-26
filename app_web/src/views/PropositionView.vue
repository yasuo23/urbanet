<template>
    <div class="flexed-page">
        <div class="slider-container">
            <AppSlideBar />
        </div>
        <div class="main-content">
            <AppNavBar title="Propositions" />
            <v-card class="body1">
                <ProposData/>
            </v-card>
    
        </div>
    </div>
</template>

<script>
import AppSlideBar from "../components/AppSlideBar";
import AppNavBar from "../components/AppNavBar.vue";
import FoncData from "../components/FoncData.vue";
import ProposData from "../components/PropositionsData.vue";

export default {
    name: "signalements",
    components: {
        AppSlideBar,
        AppNavBar,   
        FoncData,   
        ProposData
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

.body1 {
    margin: 0px 20px;
}
</style>