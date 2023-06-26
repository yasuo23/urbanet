<template>
    <div class="flexed-page">
        <div class="slider-container">
            <AppSlideBar />
        </div>
        <div class="main-content">
            <AppNavBar title="Signalement" />
            <AnomaliesData v-if="isAdmin" class="body" />
            <AnomaliesDataFF v-else class="body" />
        </div>
    </div>
</template>

<script>
import AppSlideBar from "../components/AppSlideBar";
import AppNavBar from "../components/AppNavBar.vue";
import AnomaliesData from "@/components/AnomaliesData.vue";
import AnomaliesDataFF from "@/components/AnomaliesDataFF.vue";

import supabase from "../supabase";

export default {
    name: "signalements",
    components: {
        AppSlideBar,
        AppNavBar,
        AnomaliesData,
        AnomaliesDataFF
    },

    data() {
        return {
            isAdmin: false,
        }
    },

    beforeMount (){
        this.checkRole();
    },

    methods: {
        async checkRole(){
            const { data: { user }, error } = await supabase.auth.getUser();
            if (error) {
                console.error("Error fetching user:", error);
                return;
            }

            this.user = user;
            console.log("Userjj:", this.user.email);

            if (this.user.email == "admin@gmail.com") {
                this.isAdmin = true;
                return;
            }
            else {
                this.isAdmin = false;
            }
        }
    }
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