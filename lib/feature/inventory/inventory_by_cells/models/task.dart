
class InventoryByCellsTasks {
  final List<InventoryByCellsTask> inventoryTasks;
  final String errorMassage;

  InventoryByCellsTasks(
      {required this.inventoryTasks, required this.errorMassage});


      static final empty = InventoryByCellsTasks(inventoryTasks: [], errorMassage: '');

}

class InventoryByCellsTask {
  final String taskNumber;
  final String codeCell;
  final String nameCell;

  InventoryByCellsTask(
      {required this.taskNumber,
      required this.codeCell,
      required this.nameCell});

      static final empty = InventoryByCellsTask(taskNumber: '', codeCell: '', nameCell: '');

}
