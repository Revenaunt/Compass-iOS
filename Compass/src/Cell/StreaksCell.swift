//
//  StreaksCell.swift
//  Compass
//
//  Created by Ismael Alonso on 8/15/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit;
import Charts;


class StreaksCell: UITableViewCell{
    @IBOutlet weak var chart: BarChartView!
    
    
    func setStreaks(streaks: [FeedData.Streak]){
        var streakCounts: [BarChartDataEntry] = [];
        var days: [String] = [];
        var max: Int = 0;
        
        for i in 0 ..< streaks.count{
            let streakCount = streaks[i].getCount() == 0 ? 0.1 : Double(streaks[i].getCount());
            let count = BarChartDataEntry(value: streakCount, xIndex: i);
            streakCounts.append(count);
            days.append(streaks[i].getDay());
            
            if (streaks[i].getCount() > max){
                max = streaks[i].getCount();
            }
        }
        
        let chartDataSet = BarChartDataSet(yVals: streakCounts, label: "");
        chartDataSet.colors = [UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)];
        
        let chartData = BarChartData(xVals: days, dataSet: chartDataSet);
        let formatter = NSNumberFormatter();
        formatter.maximumFractionDigits = 0
        chartData.setValueFormatter(formatter);
        chart.data = chartData;
        
        
        
        if (max == 0){
            chart.leftAxis.axisMaxValue = 1.0;
        }
        else{
            chart.leftAxis.axisMaxValue = Double(max)*1.25;
        }
        chart.leftAxis.enabled = false;
        chart.rightAxis.enabled = false;
        
        chart.xAxis.labelPosition = .Bottom;
        chart.xAxis.drawGridLinesEnabled = false;
        chart.xAxis.drawAxisLineEnabled = false;
        
        chart.descriptionText = "";
        chart.legend.enabled = false;
        chart.animate(xAxisDuration: 0.5, yAxisDuration: 1.0);
        
    }
}
