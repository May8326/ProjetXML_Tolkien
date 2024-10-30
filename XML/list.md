# List of elements and attributes used

| Element         | Attribute                | Attribute Value               |
| --------------- | ------------------------ | ----------------------------- |
| TEI             | @xmlns                   | "http://www.tei-c.org/ns/1.0" |
| teiHeader       |                          |                               |
| fileDesc        |                          |                               |
| titleStmt       |                          |                               |
| title           |                          |                               |
| publicationStmt |                          |                               |
| publisher       |                          |                               |
| sourceDesc      |                          |                               |
| bibl            | @type @xml:lang          | #REQUIRED #ID                 |
| author          |                          |                               |
| editor          | @resp                    | #REQUIRED                     |
| pubPlace        |                          |                               |
| date            | @when @type @when-custom | #IMPLIED #IMPLIED #IMPLIED    |
| biblScope       | @unit @from @to          | #REQUIRED                     |
| profileDesc     |                          |                               |
| particDesc      |                          |                               |
| listPerson      |                          |                               |
| org             | @type @xml:id            | #REQUIRED #ID                 |
| person          | @xml:id                  | #ID                           |
| settingDesc     |                          |                               |
| listPlace       |                          |                               |
| place           | @xml:id @type            | #ID #REQUIRED                 |
| text            |                          |                               |
| body            |                          |                               |
| div             | @type @n                 | #REQUIRED #REQUIRED           |
| head            |                          |                               |
| gap             | @reason @quantity        | #IMPLIED #IMPLIED             |
| p               | @type                    | #IMPLIED                      |
| persName        | @ref                     | #IDREF                        |
| geogName        | @ref                     | #IDREF                        |
| orgName         | @ref                     | #IDREF                        |
| quote           | @who @toWhom             | #REQUIRED #IMPLIED            |
| objectName      | @type                    | #REQUIRED                     |
