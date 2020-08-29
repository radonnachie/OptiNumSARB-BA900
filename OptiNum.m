fileNameFilter = ["34118.csv", "25046.csv", "TOTAL.csv"];

ba900files = dir('**/*.csv');
ba900FileList = {ba900files.folder; ba900files.name};

filteredFileListIndices = find(contains(ba900FileList(2,:), fileNameFilter));

for i = 1:size(filteredFileListIndices,2)
    filePath = string(join(ba900FileList(:,filteredFileListIndices(i)), '\'));
    sheets(i) = BA900Sheet(filePath);
    
    dates(i) = string(sheets(i).header{'Date', 1});
    institutions(i) = string(sheets(i).header{'Institution', 1});
end

dates = unique(dates);
institutions= unique(institutions);

depositCells = {};
loanCells = {};
for i = 1:size(sheets,2)
    rowIndex = find(strcmp(institutions, sheets(i).header{'Institution', 1}));
    colIndex = find(strcmp(dates, sheets(i).header{'Date', 1}));

    depositCells(rowIndex, colIndex) = sheets(i).subtables(1).table{'"1"', '"TOTAL(7)"'};
    subtable = getSubtableWithItemNumber(sheets(i), 110);
    loanCells(rowIndex, colIndex) = subtable{'"110"', '"TOTAL ASSETS (Col 1 plus col 3)(5)"'};
end

metrics.Deposits = cell2table(depositCells);
metrics.Deposits.Properties.RowNames = institutions;
metrics.Deposits.Properties.VariableNames = dates;

metrics.Loans = cell2table(loanCells);
metrics.Loans.Properties.RowNames = institutions;
metrics.Loans.Properties.VariableNames = dates;

metrics
