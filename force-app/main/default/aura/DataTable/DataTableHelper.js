({
    loadData: function(c, h) {
        const recordIds = c.get("v.recordIds");
        const offset = c.get("v.offset");
        const loadSize = Math.min(c.get("v.pageSize"), recordIds.length - offset);

        c.find("dataTable").set("v.isLoading", true);

        h.getRecords(c, h, c.get('v.objectName'), JSON.stringify(c.get('v.fields')), JSON.stringify(recordIds.slice(offset, offset + loadSize)))
        .then($A.getCallback(function (records) {
            records.forEach(function(record, index){
                record = h.flatten(c, h, record, c.get('v.objectName'));
                record = h.setKeysToLowerCase(c, h, record);
                records[index] = record;
            });
            return records;
        }))
        .then($A.getCallback(function (records) {
            const types = c.get('v.fields').reduce(function(prev, field) {
                prev[field.path] = field.type;
                return prev;
            }, {});
            records.forEach(function(record){
                Object.keys(record).forEach(function(key) {
                    if (types[key] === "BOOLEAN") {
                        if (record[key] === true) record[key] = c.get('v.true');
                        if (record[key] === false) record[key] = c.get('v.false');
                    } else if (types[key] === "TIME") {
                        if (record[key]) record[key] = moment.utc("1970-01-01 "+record[key]).format('HH:mm');
                    } else if (types[key] === "PERCENT") {
                        if (record[key]) record[key] = record[key]/100.0;
                    }
                });
            });
            return records;
        }))
        .then($A.getCallback(function (records) {
            if (recordIds !== c.get("v.recordIds")) return ;
            const data =  c.get("v.data").concat(records);
            c.set("v.data", data);
            c.set("v.offset", data.length);
            if (data.length === recordIds.length) {
               c.find("dataTable").set('v.enableInfiniteLoading', false);
            }
        }))
        .catch(function(reason) {
            h.showError(c, h, reason);
        })
        .then($A.getCallback(function () {
            c.find("dataTable").set("v.isLoading", false);
        }));
    },
    createColumn: function(c, h, field) {
        switch (field.type) {
            case 'STRING':
                if (field.isNameField) {
                    return {
                        label: field.label,
                        sortable: true,
                        type: 'button',
                        typeAttributes: {name: "showDetail", label: {fieldName: field.path}, variant: "base"},
                        fieldName: field.path,
                    }
                }
            case 'PICKLIST':
            case 'ID':
            case 'TEXTAREA':
            case 'BOOLEAN':
            case 'ADDRESS':
            case 'TIME':
                return {
                    label: field.label,
                    type: 'text',
                    fieldName: field.path,
                    sortable: true,
                };
            case 'INTEGER':
            case 'DOUBLE':
                return {
                    label: field.label,
                    type: 'number',
                    fieldName: field.path,
                    sortable: true,
                };
            case 'DATE':
                return {
                    label: field.label,
                    type: 'date',
                    fieldName: field.path,
                    sortable: true,
                };
            case 'DATETIME':
                return {
                    label: field.label,
                    type: 'date',
                    fieldName: field.path,
                    sortable: true,
                    typeAttributes: {year: "numeric", month: "numeric", day: "numeric", hour: "2-digit", minute: "2-digit" }
                };
            case 'PERCENT':
                return {
                    label: field.label,
                    type: 'percent',
                    fieldName: field.path,
                    sortable: true,
                    typeAttributes: { maximumFractionDigits : field.scale }
                };
            default:
                return {
                    label: field.label,
                    type: field.type ? field.type.toLowerCase() : '',
                    fieldName: field.path,
                    sortable: true,
                };
        }
    },
    navigateToSObject: function(c, h, recordId) {
        $A.get("e.force:navigateToSObject").setParams({
            "recordId": recordId,
        }).fire();
    },
    flatten: function(c, h, data, objectName) {
        var result = {};
        function recurse (cur, prop) {
            if (Object(cur) !== cur) {
                result[prop] = cur;
            } else if (Array.isArray(cur)) {
                for(var i=0, l=cur.length; i<l; i++)
                    recurse(cur[i], prop + "[" + i + "]");
                if (l == 0)
                    result[prop] = [];
            } else {
                var isEmpty = true;
                for (var p in cur) {
                    isEmpty = false;
                    recurse(cur[p], prop ? prop+"."+p : p);
                }
                if (isEmpty && prop)
                    result[prop] = {};
            }
        }
        recurse(data, objectName);
        return result;
    },
    setKeysToLowerCase: function(c, h, obj) {
        var key, keys = Object.keys(obj);
        var n = keys.length;
        var result = {};
        while (n--) {
            key = keys[n];
            result[key.toLowerCase()] = obj[key];
        }
        return result;
    },

    getValue: function(c, h, field, record) {
        const path = field.path.split('.');
        path.shift();
        let value = record;
        path.forEach(function(key) {
            if (value) value = value[key];
        });
        return value;
    },
    getData: function(c, h, field, record) {
        const path = field.path.split('.');
        path.shift();
        const data = {
            value : record,
            id : record.Id,
            label : field.label,
            isNameField : field.isNameField
        };
        path.forEach(function(key) {
            if (data.value) {
                data.id = data.value.Id;
                data.value = data.value[key];
            }
        });
        return data;
    },
    getFields: function(c, h, objectName, fieldNames) {
        const action = c.get('c.getFields');
        action.setParams({
            objectName: objectName,
            fieldNames: fieldNames,
        });
        return new Promise(function (resolve, reject) {
            action.setCallback(this, function(response) {
                const ret = response.getReturnValue();
                if (response.getState() === 'SUCCESS') ret.hasError ? reject(ret.message) : resolve(ret);
                else if (response.getState() === 'ERROR') reject(response.getError());
            });
            $A.enqueueAction(action);
        });
    },
    getRecords: function(c, h, objectName, fieldsJson, recordIdsJson) {
        const action = c.get('c.getRecords');
        action.setParams({
            objectName: objectName,
            fieldsJson: fieldsJson,
            recordIdsJson: recordIdsJson
        });
        return new Promise(function (resolve, reject) {
            action.setCallback(this, function(response) {
                const ret = JSON.parse(response.getReturnValue());
                if (response.getState() === 'SUCCESS') ret.hasError ? reject(ret.message) : resolve(ret);
                else if (response.getState() === 'ERROR') reject(response.getError());
            });
            $A.enqueueAction(action);
        });
    },
    showSuccessToast: function(c, h, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: 'success',
            mode : 'pester',
            message: message,
            duration: 3000
        });
        toastEvent.fire();
    },
    showError: function(c, h, message) {
        const isOnAppBuilder = document.location.href.toLowerCase().indexOf('flexipageeditor') >= 0;
        if (isOnAppBuilder) {
            console.error(message);
            c.set('v.errorMessage', message);
        } else {
            const toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                type: 'error',
                mode : 'sticky',
                message: message,
            });
            toastEvent.fire();
        }
    }
})