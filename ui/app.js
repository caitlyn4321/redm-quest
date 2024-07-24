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
            newrequirement: {item : null, count : 0},
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
        delQuestEntry(data,quest) {
            fetch(`https://${GetParentResourceName()}/delquestentry`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ entry :data, quest: this.quest_id})
            }).then(response => response.json())
              .then(result => {}).catch(error => {});
              this.selectQuest(quest);
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
        editQuestEntry(data) {
            this.setpage(5);
            fetch(`https://${GetParentResourceName()}/editquestentry`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            }).then(response => response.json())
              .then(result => {}).catch(error => {});
        },
        updateEntry() {
            fetch(`https://${GetParentResourceName()}/updateentry`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(this.questentry)
            }).then(response => response.json())
              .then(result => {}).catch(error => {});
        },
        addRequirement(data) {
            console.table(this.questentry.config.requirements.items);
            switch(data) {
                case 0:
                    this.questentry.config.requirements.items.push({item: this.newrequirement.item, count: this.newrequirement.count});
                    break;
                case 1:
                    this.questentry.config.materials.items.push({item: this.newrequirement.item, count: this.newrequirement.count});
                    break;
                case 2:
                    this.questentry.config.rewards.items.push({item: this.newrequirement.item, count: this.newrequirement.count});
                    break;
            }
            console.table(this.questentry.config.requirements.items);

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