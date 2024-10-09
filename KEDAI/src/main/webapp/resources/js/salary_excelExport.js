document.addEventListener('DOMContentLoaded', function() {
    // 엑셀 다운로드 버튼 클릭 시 엑셀 파일 생성 및 다운로드
    document.querySelector('#downloadExcel').addEventListener('click', makeFile);
    
    async function makeFile(e) {
        e.preventDefault(); // 기본 동작 방지 (폼 제출 등)

        const selectedValue = document.getElementById('yearMonth').value;
        const workbook = new ExcelJS.Workbook();
        const sheet = workbook.addWorksheet('급여명세서');

        // 스타일 설정
        const headerStyle = {
            font: { bold: true, size: 16, color: { argb: 'FFFFFF' } },
            alignment: { horizontal: 'center', vertical: 'middle' },
            fill: { type: 'pattern', pattern: 'solid', fgColor: { argb: '4472C4' } }
        };

        const subHeaderStyle = {
            font: { bold: true, size: 12, color: { argb: 'FFFFFF' } },
            alignment: { horizontal: 'center', vertical: 'middle' },
            fill: { type: 'pattern', pattern: 'solid', fgColor: { argb: '5B9BD5' } }
        };

        const normalStyle = {
            alignment: { horizontal: 'center', vertical: 'middle' },
            border: {
                top: { style: 'thin' },
                left: { style: 'thin' },
                bottom: { style: 'thin' },
                right: { style: 'thin' }
            }
        };

        const warningStyle = {
            font: { color: { argb: 'FF0000' } }
        };

        // 데이터 삽입
        sheet.mergeCells('A1:D1');
        const titleCell = sheet.getCell('A1');
        titleCell.value = '급여명세서';
        titleCell.style = headerStyle;

        // 선택된 연도와 월 가져오기
        const selectedDate = document.getElementById('yearMonth').value;
        sheet.mergeCells('A2:D2');
        const dateCell = sheet.getCell('A2');
        dateCell.value = '급여지급일 : ' + selectedDate + ' 10일';
        dateCell.style = normalStyle;

        // 개인 정보
        sheet.addRow(['이름', document.getElementById('employeeName').textContent.trim(), '부서', document.getElementById('employeeDepartment').textContent.trim()]);
        sheet.addRow(['직위', document.getElementById('employeePosition').textContent.trim(), '입사일자', document.getElementById('employeeHireDate').textContent.trim()]);
        sheet.getRow(3).eachCell(cell => { cell.style = normalStyle; });
        sheet.getRow(4).eachCell(cell => { cell.style = normalStyle; });

        // 세부 내역 헤더
        sheet.addRow([]);
        sheet.addRow(['', '', '세부 내역', '']);
        sheet.mergeCells('C5:D5');
        const detailHeaderCell = sheet.getCell('C5');
        detailHeaderCell.value = '세부 내역';
        detailHeaderCell.style = subHeaderStyle;

        const salaryDetails = document.querySelectorAll('#salaryDetails tr');
        salaryDetails.forEach(row => {
            const cells = row.querySelectorAll('td');
            if (cells.length > 0) {
                const rowData = Array.from(cells).map(cell => {
                    // input 필드가 있으면 그 value를 사용하고, 없으면 textContent를 사용
                    const input = cell.querySelector('input');
                    return input ? input.value.trim() : cell.textContent.trim();
                });
                const newRow = sheet.addRow(rowData);
                newRow.eachCell((cell, colNumber) => {
                    cell.style = normalStyle;
                    if (colNumber === 2 && cell.value === '실지급액') {
                        cell.style = warningStyle;
                    }
                });
            }
        });

        // 엑셀 파일 다운로드
        await download(workbook, selectedDate + ' 급여명세서');
    }

    const download = async (workbook, fileName) => {
        const buffer = await workbook.xlsx.writeBuffer();
        const blob = new Blob([buffer], {
            type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        });
        const url = window.URL.createObjectURL(blob);
        const anchor = document.createElement('a');
        anchor.href = url;
        anchor.download = fileName + '.xlsx';
        document.body.appendChild(anchor); // for Firefox
        anchor.click();
        document.body.removeChild(anchor); // cleanup
        window.URL.revokeObjectURL(url);
    };
});
