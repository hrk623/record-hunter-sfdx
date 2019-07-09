({
    onInit: function(c, e, h) {

        // Then we we need to initialize the columns of table.
        const fieldNames = c.get("v.fieldNames").split(",").map(function(fieldName) {
            return fieldName.trim().toLowerCase();
        });
        if (fieldNames.length === 1 && !fieldNames[0]) fieldNames.shift();
        const p_getFields = fieldNames.length ? h.getFields(c, h, c.get("v.objectName"), fieldNames.join(',')) : Promise.resolve([]);

        p_getFields
        .then($A.getCallback(function(fields) {

            // First, we will pre-process the fields.
            // This step includes;
            // 1. invalidate Fields which are not supported or may cause a malfunctioning for this component
            // 2. invalidate Fields which are not supported by this component
            fields = fields.filter(function(field) {
                if (!field || !field.isAccessible) return false;
                else if (field.type === "ADDRESS" || field.type === "REFERENCE" || field.type === "ANYTYPE"
                         || field.type === "BASE64" || field.type === "DATACATEGORYGROUPREFERENCE" || field.type === "ENCRYPTEDSTRING") {
                    h.showError(c, h, `The type '${field.type}' for '${field.name}' of '${field.objectName}' is unsupported.`);
                    return false;
                } else {
                    return true;
                }
            });
            return fields;
        }))
        .then($A.getCallback(function(fields) {
            const columns = fields.map(function(field) {
                return h.createColumn(c, h, field);
            });
            c.set('v.columns', columns);
            c.set('v.fields', fields);
        }))
        .catch(function(reason) {
            h.showError(c, h, "controller.initColumns : " + reason);
        });
    },
    onSetRecordIds: function(c, e, h) {
        const args = e.getParam('arguments');
        c.find('dataTable').set("v.enableInfiniteLoading", true);
        c.set('v.offset', 0);
        c.set('v.recordIds', args.recordIds);
        c.set('v.data', []);
        h.loadData(c, h);
    },
    onReload: function (c, e, h) {
        c.find('dataTable').set('v.enableInfiniteLoading', true);
        c.set('v.offset', 0);
        c.set('v.data', []);
        h.loadData(c, h);
    },
    onGetSelectedIds: function (c, e, h) {
        return c.find('dataTable').getSelectedRows().reduce(function(prev, row) {
            prev.push(row[c.get('v.objectName').toLowerCase() + '.id' ]);
            return prev;
        }, []);
    },
    onLoadMoreData: function (c, e, h) {
        if (c.get("v.recordIds").length > c.get("v.data").length) h.loadData(c, h);
    },
    onRowAction : function (c, e, h) {
        const action = e.getParam('action');
        const row = e.getParam('row');
        switch (action.name) {
            case 'showDetail':
                const key = action.label.fieldName;
                const pathForId = key.substring(0, key.lastIndexOf(".")) + ".id";
                h.navigateToSObject(c, h, row[pathForId]);
                break;
        }
    },
    onSort: function (c, e, h) {
        let fieldName = e.getParam('fieldName');
        const sortDirection = e.getParam('sortDirection');
        c.set("v.sortedBy", fieldName);
        c.set("v.sortedDirection", sortDirection);
        const data = c.get("v.data");
        data.sort(function(a, b) {
            let val1 = a[fieldName], val2 = b[fieldName];
            val1 = typeof val1 === 'string' || val1 instanceof String ? val1.toUpperCase() : val1;
            val2 = typeof val2 === 'string' || val2 instanceof String ? val2.toUpperCase() : val2;
            const reverse = sortDirection === 'asc' ? 1 : -1;
            if(val1 === undefined) return -1 * reverse;
            if(val2 === undefined) return 1 * reverse;
            if(val1 < val2) return -1 * reverse;
            if(val1 > val2) return 1 * reverse;
            return 0;
        })
        c.set("v.data", data);
    },

})