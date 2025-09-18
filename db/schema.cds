using { cuid, managed, sap.common.CodeList } from '@sap/cds/common';
namespace my.incidents;

// These are the incidents created by Customers.
entity incidents: cuid, managed {
    customer: Association Customers;
    title: String @title: 'Title';
    urgency: Association to Urgency default 'M';
    status: Association to Status default 'N';
    conversation: Composition of many {
        key ID: UUID;
        timestamp: type of managed: createdAt;
        author: type of managed: createdBy;
        message: String;
    };
}

// Customers entitled to create support Incidents.
entity Customers: managed {
    key ID: String;
}