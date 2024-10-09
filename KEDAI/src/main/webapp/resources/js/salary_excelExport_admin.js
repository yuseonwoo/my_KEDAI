document.addEventListener('DOMContentLoaded', function() {
    // 엑셀 다운로드 버튼 클릭 시 엑셀 파일 생성 및 다운로드
    document.querySelector('#dwd').addEventListener('click', makeFile);
        
    async function makeFile(e) {
        e.preventDefault(); // 기본 동작 방지 (폼 제출 등)

        const selectedValue = document.getElementById('yearMonth').value;
        const response = await fetch(`/salaryData.kedai?yearMonth=${selectedValue}`);
        const data = await response.json();

        if (Array.isArray(data) && data.length > 0) {
            const workbook = new ExcelJS.Workbook();

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

            data.forEach(employeeData => {
                const sheet = workbook.addWorksheet(employeeData.namd);

                // 데이터 삽입
                sheet.mergeCells('A1:D1');
                const titleCell = sheet.getCell('A1');
                titleCell.value = '급여명세서';
                titleCell.style = headerStyle;

                // 선택된 연도와 월 가져오기
                sheet.mergeCells('A2:D2');
                const dateCell = sheet.getCell('A2');
                dateCell.value = '급여지급일 : ' + selectedValue + ' 10일';
                dateCell.style = normalStyle;

                // 개인 정보
                sheet.addRow(['이름', employeeData.namd, '부서', employeeData.department || '']);
                sheet.addRow(['직위', employeeData.position || '', '입사일자', employeeData.hireDate || '']);
                sheet.getRow(3).eachCell(cell => { cell.style = normalStyle; });
                sheet.getRow(4).eachCell(cell => { cell.style = normalStyle; });

                // 세부 내역 헤더
                sheet.addRow([]);
                sheet.addRow(['', '', '세부 내역', '']);
                sheet.mergeCells('C5:D5');
                const detailHeaderCell = sheet.getCell('C5');
                detailHeaderCell.value = '세부 내역';
                detailHeaderCell.style = subHeaderStyle;

                // 세부 내역 데이터 삽입
                const details = [
                    ['기본급', employeeData.base_salary],
                    ['식대', employeeData.meal_allowance],
                    ['연차수당', employeeData.annual_allowance],
                    ['초과근무수당', employeeData.overtime_allowance],
                    ['소득세', employeeData.income_tax],
                    ['지방소득세', employeeData.local_income_tax],
                    ['연금', employeeData.pension],
                    ['건강보험', employeeData.health_insurance],
                    ['고용보험', employeeData.employment_insurance],
                    ['총소득', employeeData.total_income],
                    ['총공제', employeeData.total_deduction],
                    ['실지급액', employeeData.net_pay]
                ];

                details.forEach(detail => {
                    const newRow = sheet.addRow(['', '', detail[0], detail[1]]);
                    newRow.eachCell((cell, colNumber) => {
                        cell.style = normalStyle;
                        if (colNumber === 2 && cell.value === '실지급액') {
                            cell.style = warningStyle;
                        }
                    });
                });
            });

            // 엑셀 파일 다운로드
            await download(workbook, selectedValue + ' 급여명세서');
        } else {
            alert("서버에서 반환된 데이터가 올바르지 않습니다.");
        }
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
