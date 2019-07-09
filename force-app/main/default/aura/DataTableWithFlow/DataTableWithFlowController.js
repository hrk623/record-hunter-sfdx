({
    onInit: function(c, e, h) {
        const flowNames = (c.get('v.flowNames') || '') .split(',').map(function(flowName) { return flowName.trim(); });
        if (flowNames.length === 1 && !flowNames[0]) flowNames.shift();

        const flowLabels = (c.get('v.flowLabels') || '').split(',').map(function(flowLabel) { return flowLabel.trim(); });
        if (flowLabels.length === 1 && !flowLabels[0]) flowLabels.shift();

        const flows = flowNames.map(function (flowName, index) {
            return {
                name: flowName,
                label: flowLabels.length > index && flowLabels[index] ? flowLabels[index] : flowName,
            };
        });
        c.set('v.flows', flows);
    },
    onSearchResultEvent: function(c, e, h) {
        const order = parseInt(c.get('v.order'));
        const origin = e.getParam('origin');
        if (origin + 1 === order) {
            const recordIds = e.getParam('recordIds');
            c.set('v.recordIds', recordIds);
            c.find('datatable').setRecordIds(recordIds);
        }
    },
    onFlowSelected: function (c, e, h) {

        const flowInput = c.get('v.flowInput');
        const recordId = c.get('v.recordId');

        const selectedIds = c.find('datatable').getSelectedIds();
        if (flowInput === 'ID') {
            h.initFlowComponent(c, h)
            .then($A.getCallback(function(flowComponent) {
                c.set('v.modalBody', [flowComponent]);
                flowComponent.startFlow(e.getParam('value'), [{
                    name : 'contextId',
                    type : 'String',
                    value: recordId
                }, {
                    name : 'selectedIds',
                    type : 'String',
                    value: selectedIds
                }]);
            }))
            .catch(function(reason) {
                h.showError(c, h, 'controller.onFlowSelected : ' + reason);
            });

        } else if (flowInput === 'RECORD') {
            const getRecordResult = recordId ? h.getRecord(c, h, recordId) : Promise.resolve({Id: ''});
            const getRecordsResult = selectedIds && selectedIds.length > 0 ? h.getRecords(c, h, selectedIds) : Promise.resolve([]);
            Promise.all([getRecordResult, getRecordsResult])
            .then($A.getCallback(function([record, records]) {
                h.initFlowComponent(c, h)
                .then($A.getCallback(function(flowComponent) {
                    c.set('v.modalBody', [flowComponent]);
                    flowComponent.startFlow(e.getParam('value'), [{
                        name : 'contextRecord',
                        type : 'SObject',
                        value: record
                    }, {
                        name : 'selectedRecords',
                        type : 'SObject',
                        value: records
                    }]);
                }));
            }))
            .catch($A.getCallback(function(reason) {
                h.showError(c, h, 'controller.onStartFlowWithRecords: ' + reason);
            }));
        }
    },
    onFlowStatusChanged: function (c, e, h) {
        switch(e.getParam('status')) {
            case 'FINISHED':
                c.set('v.modalBody', []);
                c.find('datatable').reload();
                break;
            case 'FINISHED_SCREEN':
            case 'STARTED':
            case 'PAUSED':
            case 'ERROR':
                break;
        }
    },
    onFlowClosed: function (c, e, h) {
        c.set('v.modalBody', []);
    },
})