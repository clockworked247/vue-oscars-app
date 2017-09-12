import Vue from 'vue'
import _ from 'lodash'
import results from '../../data/results';

const state = {
    currentQuery: '',
    currentDoc: null,
    activeFacets: [],
    results  // from above import
};

const mutations = {
    'SET_RESULTS' (state, results) {
        state.results = results;
    },
    'ADD_FACET' (state, facet) {
        state.activeFacets.push(facet);
    },
    'REMOVE_FACET' (state, facet) {
        state.activeFacets = _.difference(state.activeFacets, [ facet ]);
    },
    'UPDATE_CURRENT_QUERY' (state, query) {
        state.currentQuery = query;
    },
    'SET_FACETS' (state, facets) {
        state.activeFacets = facets;
    },
    'UPDATE_CURRENT_DOC' (state, doc) {
        state.currentDoc = doc;
    },
    'CLEAR_CURRENT_DOC' (state) {
        state.currentDoc = null;
    }
};

const actions = {
    performSearch: ({commit, state}) => {
        var searchObj = {
                        "query":{
                            "qtext":state.currentQuery || "",
                            "and-query":{
                                "queries":[]
                            }
                        }
                    };
        if (state.activeFacets.length > 0) 
            _.forEach(state.activeFacets, function(facet) {
                searchObj.query["and-query"].queries.push({"range-constraint-query":{"constraint-name":facet.type,"value":[facet.value]}});
            });
        else delete searchObj.query["and-query"];

        if (state.currentQuery) 
            searchObj.query.qtext = state.currentQuery;
        else delete searchObj.query.qtext;

        Vue.http.post('search?format=json&view=all&options=all&start=1&pageLength=10', searchObj)
            .then(response => response.json())
            .then(data => {
                if (data) {
                    commit('SET_RESULTS', data.results);
                }
            });
    },
    addFacet: ({commit}, facet) => {
        commit('ADD_FACET', facet);
    },
    removeFacet: ({commit}, facet) => {
        commit('REMOVE_FACET', facet);
    },
    initCurrentQuery: ({commit}, query) => {
        commit('UPDATE_CURRENT_QUERY', query);
    },
    updateCurrentQuery: ({commit}, query) => {
        commit('UPDATE_CURRENT_QUERY', query);
    },
    setActiveFacets: ({commit}, facets) => {
        commit('SET_FACETS', facets);
    },
    clearDoc: ({commit}) => {
        commit('CLEAR_CURRENT_DOC');
    }
};

const getters = {
    results: state => {
        return state.results;
    },
    activeFacets: state => {
        return state.activeFacets;
    },
    currentQuery: state => {
        return state.currentQuery;
    },
    currentDoc: state => {
        return state.currentDoc;
    }
};

export default {
    state,
    mutations,
    actions,
    getters
};