using { cuid, managed, sap.common.CodeList } from '@sap/cds/common';
namespace my.incidents;

type EmailAddress : String;
type PhoneNumber : String;

// These are the incidents created by Customers.
entity Incidents: cuid, managed {
    customer: Association to Customers;
    title: String @title: 'Title';
    status: Association to Status default 'N';
    urgency: Association to Urgency default 'M';
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
    firstname: String;
    lastname: String;
    name: String = trim(firstname || ' ' || lastname);
    email: EmailAddress;
    phone: PhoneNumber;
    incidents: Association to many Incidents on incidents.customer = $self;
    creditCardInfo: String(16) @assert.format : '^[1-9]\d{15}$';
    address: Composition of many Addresses on address.customer = $self;
}

// Addresses each customer holds..
entity Addresses: cuid, managed {
    customer: Association to Customers;
    city: String;
    postalCode: String;
    streetAddress: String;
}

// Status
entity Status: CodeList {
    key code: String enum {
        newStatus = 'N';
        assigned = 'A';
        in_process = 'I'; 
        on_hold = 'H'; 
        resolved = 'R'; 
        closed = 'C'; 
    };
    criticality: Integer;
}

// Urgency..
entity Urgency: CodeList {
    key code: String enum {
        high = 'H';
        medium = 'M'; 
        low = 'L'; 
    };
}