const cds = require('@sap/cds');

class ProcessorService extends cds.ApplicationService {
    init() {
        this.before("UPDATE", "Incidents", (req) => this.onUpdate(req));
        this.before("CREATE", "Incidents", (req) => this.changeUrgencyDueToSubject(req.data));

        return super.init();
    }

    // it will set urgency to HIGH, when you will create with a title ..Urgent..
    changeUrgencyDueToSubject(data) {
        let urg = data.title?.match(/urgent/i);
        if (urg) data.urgency_code = 'H';
    }

    // custom validation..
    async onUpdate(req) {
        let closed = await SELECT.one(1).from(req.subject).where`status.code = 'C`;
        if (closed) req.reject`Can't modify a closed incident!`
    }


    // ... same way ...
    // init() {

    //     const { Incidents } = this.entities

    //     this.before('UPDATE', Incidents, async req => {
    //         let closed = await SELECT.one(1).from(req.subject).where`status.code = 'C'`
    //         if (closed) req.reject`Can't modify a closed incident!`
    //     })

    //     this.before(['CREATE', 'UPDATE'], Incidents, req => {
    //         let urgent = req.data.title?.match(/urgent/i)
    //         if (urgent) req.data.urgency_code = 'H'
    //     })

    //     return super.init()
    // }
}

module.exports = { ProcessorService };