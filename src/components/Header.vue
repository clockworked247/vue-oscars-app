<template>
    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <div class="navbar-header">
                <router-link to="/" class="navbar-brand">Oscars App</router-link>
            </div>

            <div class="collapse navbar-collapse">
                <ul class="nav navbar-nav">
                    <router-link to="/app" activeClass="active" tag="li"><a>App</a></router-link>
                    <router-link to="/queries" activeClass="active" tag="li"><a>Queries</a></router-link>
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    <li
                            class="dropdown"
                            :class="{open: isDropdownOpen}"
                            @click="isDropdownOpen = !isDropdownOpen">
                        <a
                                href="#"
                                class="dropdown-toggle"
                                data-toggle="dropdown"
                                role="button"
                                aria-haspopup="true"
                                aria-expanded="false">Save & Load <span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="#" @click="svData">Save Data</a></li>
                            <li><a href="#" @click="ldData">Load Data</a></li>
                        </ul>
                    </li>
                </ul>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
</template>

<script>
    import {mapActions} from 'vuex';

    export default {
        data() {
          return {
              isDropdownOpen: false
          }
        },
        computed: {
            funds() {
                return this.$store.getters.funds;
            }
        },
        methods: {
            ...mapActions([
                'loadData',
                'saveData'
            ]),
            svData() {
                const data = {
                    queries: this.$store.getters.queries,
                    currentQuery: this.$store.getters.currentQuery,
                    activeFacets: this.$store.getters.activeFacets
                };
                this.saveData(data);
            },
            ldData() {
                this.loadData();
            }
        }
    }
</script>