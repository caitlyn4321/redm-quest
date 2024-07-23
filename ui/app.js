const { createApp } = Vue;

const app = createApp({
    data() {
        return {
            page: 0, 
            meta : null,
            quests: {},
            quest_entries: {},
            quest_name: '',
            quest_desc: '',
            quest_id: 1,
            questentry: {},
        };
    },
    methods: {
        handleMessage(event) {
            if (event.data.type === 'display') {
                this.setpage(1);
                console.log("display");
            } else if (event.data.type === 'questlist') {
                this.setpage(2);
                console.log("Quest Editor");
            } else if (event.data.type === 'questentries') {
                this.setpage(3);
                console.log("Quest Entry Editor");
            }

            if (event.data.meta) {
                this.meta = event.data.meta;
            }
            if (event.data.quests) {
                this.quests = event.data.quests;
            }
            if (event.data.questentries) {
                this.quest_entries = event.data.questentries;
            }
            if (event.data.quest_name) {
                this.quest_name = event.data.quest_name;
                this.quest_desc = event.data.quest_desc;
                this.quest_id = event.data.quest_id;
            }
            if (event.data.questentry) {
                this.questentry = event.data.questentry;
            }
        },
        handleKeydown(event) {
            // Handle keydown event here
            if (event.key === 'Escape') {
                this.close(null);
            }
        },
        setpage(page) {
            this.page = page;
        },
        selectQuest(data) {
            this.setpage(3);
            this.quest_id = data;

            fetch(`https://${GetParentResourceName()}/selectquest`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            }).then(response => response.json())
              .then(result => {}).catch(error => {});
        },
        editQuest(data) {
            this.setpage(4);
            fetch(`https://${GetParentResourceName()}/editquest`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            }).then(response => response.json())
              .then(result => {}).catch(error => {});
        },
        delQuest(data) {
            this.setpage(2);
            fetch(`https://${GetParentResourceName()}/delquest`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            }).then(response => response.json())
              .then(result => {}).catch(error => {});
        },
        delQuestEntry(data) {
            fetch(`https://${GetParentResourceName()}/delquestentry`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ entry :data, quest: this.quest_id})
            }).then(response => response.json())
              .then(result => {}).catch(error => {});
        },
        addQuest() {
            fetch(`https://${GetParentResourceName()}/addquest`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify()
            }).then(response => response.json())
              .then(result => {}).catch(error => {});
        },
        saveQuest(data) {
            fetch(`https://${GetParentResourceName()}/savequest`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({name: this.quest_name, desc: this.quest_desc, id: this.quest_id})
            }).then(response => response.json())
              .then(result => {}).catch(error => {});
        },
        addQuestEntry(data) {
            fetch(`https://${GetParentResourceName()}/addquestentry`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            }).then(response => response.json())
              .then(result => {}).catch(error => {});
        },
        close(data) {
            this.setpage(0);

            fetch(`https://${GetParentResourceName()}/close`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            }).then(response => response.json())
              .then(result => {}).catch(error => {});
        },
    },
    mounted() {
        window.addEventListener('message', this.handleMessage);
        window.addEventListener('keydown', this.handleKeydown);
    },
    unmounted() {
        window.removeEventListener('message', this.handleMessage);
        window.removeEventListener('keydown', this.handleKeydown);
    }
});

app.mount('#app');