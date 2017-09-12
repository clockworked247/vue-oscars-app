<template>
    <div class="panel panel-default">
        <div class="panel-heading">Oscars App</div>
        <div class="panel-body">
            <div class="row">
                <div class="col-lg-2"></div>
                <div class="col-lg-10">
                    <h1>Search</h1>
                    <div class="input-group">
                    <input type="text" class="form-control" placeholder="Search for..." v-model="query" v-on:change="doUpdateCurrentQuery" >
                    <span class="input-group-btn">
                        <button class="btn btn-success" type="button" @click="performSearch">Search</button>
                        <button class="btn btn-info" type="button" @click="doAddQuery">
                            <span class="glyphicon glyphicon-floppy-disk"></span>
                        </button>
                    </span>
                    </div><!-- /input-group -->
                </div><!-- /.col-lg-10 -->
            </div><!-- /.row -->
            <div class="row margin-top-20">
                <div class="col-lg-2" id="facets">
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <h4>Facets</h4>
                            <p>
                                <button v-for="facet in activeFacets" class="btn btn-warning btn-xs" @click="doRemoveFacet(facet)" type="button">
                                    {{ chickletText(facet) }} <span class="glyphicon glyphicon-remove"></span>
                                </button>
                            </p>
                            <hr />
                            <p>
                                <button v-for="facet in inactiveFacets" class="btn btn-warning btn-xs" @click="doAddFacet(facet)" type="button">
                                    {{ chickletText(facet) }}
                                </button>
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-10" id="results">
                    <div class="panel panel-default">

                        <!--  VIEW DOCUMENT -->
                        <div class="panel-body" v-if="currentDoc">
                            <app-doc :doc="currentDoc"></app-doc>
                            {{ currentDoc }}
                        </div>

                        <!--  VIEW RESULTS -->
                        <div class="panel-body" v-else>
                            <ul class="list-group">
                                <app-result v-for="result in results" :result="result"></app-result>
                            </ul>
                        </div>
                    </div><!-- /.panel -->    
                    
                </div><!-- /.col-lg-10 -->
                
            </div><!-- /.row -->
            
        </div><!-- /.panel-body -->
        <div class="panel-footer"></div>
    </div><!-- /.panel -->
</template>

<style>
    .margin-top-20 {
        margin-top:20px;
    }
    #facets button {
        margin: 2px;
    }
    #facets .panel {
        background-color: #e5f2ff;
    }
    #facets hr {
        border-top: 1px solid #000;
    }
</style>

<script>
    import _ from 'lodash';
    import {mapGetters} from 'vuex';
    import {mapActions} from 'vuex';
    import Result from './Result.vue';
    import Doc from './Doc.vue';

    export default {
        data() {
            return {
                query: '',
                facets: {
                    decade: [
                        { type: "decade", value: "2000s" },
                        { type: "decade", value: "1990s" },
                        { type: "decade", value: "1980s" },
                        { type: "decade", value: "1970s" },
                        { type: "decade", value: "1960s" }
                    ],
                    award: [
                        { type: "award", value: "best-director" },
                        { type: "award", value: "best-picture" },
                        { type: "award", value: "lead-actor" },
                        { type: "award", value: "lead-actress" }
                    ],
                    winners: [
                        { type: "winner", value: "true" },
                        { type: "winner", value: "false" }
                    ]
                }
            }
        },
        components: {
            appResult: Result,
            appDoc: Doc
        },
        computed: { 
            ...mapGetters(['results', 'activeFacets', 'currentDoc']),
            inactiveFacets() {
                const self = this;
                const allFacets = _.concat(this.facets.decade, this.facets.award, this.facets.winners);
                return _.filter(allFacets, function(o) { return _.findIndex(self.activeFacets,o) === -1; });
            }
        },
        methods: {
            // TODO: Add mapGetters for getting results
            ...mapActions([
                'addQuery',
                'updateCurrentQuery',
                'addFacet',
                'removeFacet',
                'performSearch'
            ]),
            chickletText(facet) {
                return facet.type + ":" + facet.value;
            },
            doAddQuery() {
                this.addQuery(this.query);
                // TODO: Add alert showing query saved
            },
            doUpdateCurrentQuery() {
                this.updateCurrentQuery(this.query);
            },
            doAddFacet(facet) {
                this.addFacet(facet);
                this.performSearch();
            },
            doRemoveFacet(facet) {
                this.removeFacet(facet);
                this.performSearch();
            }
        },
        mounted() {
            // when page loads, set current query text to stored state
            this.query = this.$store.getters.currentQuery;  
        }
    }
</script>