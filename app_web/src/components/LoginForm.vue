<template>
    <div class="container">
        <v-main class="d-flex justify-center align-center ">
            <v-col cols="10" lg="4" class="mx-auto">
                <v-card class="pa-4" style="padding: 48px;">
                    <div class="text-center">
                        <v-avatar size="100" color="indigo lighten-4">
                            <v-icon size="40" color="indigo">mdi-account</v-icon>
                        </v-avatar>
                        <h2 class="indigo--text">login Page</h2>
                    </div>
                    <v-form @submit.prevent="SignIn" ref="form">
                        <v-card-text>
                            <v-text-field v-model="email" :rules="emailRules" type="email" label="Email" placeholder="Email"
                                prepend-inner-icon="mdi-account" required />
                            <v-text-field v-model="password" :rules="passwordRules"
                                :type="passwordShow ? 'text' : 'password'" label="Password" placeholder="Password"
                                prepend-inner-icon="mdi-key" :append-icon="passwordShow ? 'mdi-eye' : 'mdi-eye-off'"
                                @click:append="passwordShow = !passwordShow" required />
                            <v-switch label="Remember me" color="indigo"></v-switch>
                        </v-card-text>
                        <v-card-actions class="justify-center">
                            <v-btn :loading="loading" type="submit" color="indigo">
                                <span class="white--text px-8">Login</span>
                            </v-btn>
                        </v-card-actions>
                    </v-form>
                </v-card>
            </v-col>
        </v-main>
        <v-snackbar top color="blue" v-model="snackbar">
            Login success
        </v-snackbar>
    </div>
</template>


<script>
import supabase from '../supabase';
export default {
    name: 'loginform',
    data: () => ({
        loading: false,
        snackbar: false,
        passwordShow: false,
        email: '',
        emailRules: [
            v => !!v || 'E-mail is required',
            v => /.+@.+\..+/.test(v) || 'E-mail must be valid',
        ],
        password: '',
        passwordRules: [
            v => !!v || 'Password is required',
            // v => (v && v.length >= 6) || 'Password must be 6  characters or more!',
        ],
    }),
    methods: {
        submitHandler() {
            if (this.$refs.form.validate()) {
                this.loading = true
                setTimeout(() => {
                    this.loading = false
                    this.snackbar = true
                }, 3000)
            }
        },
        async SignIn() {
            try {
                const { user, error } = await supabase.auth.signInWithPassword({
                    email: this.email,
                    password: this.password,
                })
                if (error) {
                    throw error
                } else {
                    console.log('dkhelna')
                    this.snackbar = true
                    this.$router.push('/dashboard')
                }
            } catch (error) {
                alert(error.message || error.error_description)
            }

        },
    }
};
</script>

<style></style>