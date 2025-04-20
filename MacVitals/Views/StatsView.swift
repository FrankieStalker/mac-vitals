import SwiftUI

import MacVitalsSystemStats

struct StatsView: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var stats: SystemStats {
        SystemStats()
    }
    
    @State private var gpuStats: GPUInfo?
    @State private var cpuStats: CPUInfo?
    @State private var ramStats: RAMInfo?
    
    private var isStatsNil: Bool {
        gpuStats == nil || cpuStats == nil || ramStats == nil
    }
    
    var body: some View {
            Group {
                if !isStatsNil {
                    TabView {
                        gpuStatsView
                        cpuStatsView
                        ramStatsView
                    }
                    .padding()
                } else {
                    Text("Awaiting stats...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .font(.headline)
                }
            }
            .onReceive(timer) { input in
                gpuStats = stats.getGPUStats()
                cpuStats = stats.getCPUStats()
                ramStats = stats.getRAMStats()
            }
    }
    
    @ViewBuilder private var gpuStatsView: some View {
        if let gpuStats {
            StatCard(
                title: "GPU Stats",
                items: [
                    ("Name", gpuStats.gpuName),
                    ("Memory", gpuStats.gpuMemory),
                    ("Utilisation", gpuStats.gpuUtilisation)
                ]
            )
            .tabItem {
                Label("GPU", systemImage: "memorychip")
            }
        }
    }
    
    @ViewBuilder private var cpuStatsView: some View {
        if let cpuStats {
            StatCard(
                title: "CPU Stats",
                items: [("Usage", cpuStats.usagePercentage)]
            )
            .tabItem {
                Label("CPU", systemImage: "cpu")
            }
        }
    }
    
    @ViewBuilder private var ramStatsView: some View {
        if let ramStats {
            StatCard(
                title: "RAM Stats",
                items: [
                    ("Total", ramStats.totalRam),
                    ("Used", ramStats.usedRam),
                    ("Free", ramStats.freeRam),
                    ("Wired", ramStats.wiredRam),
                    ("Compressed", ramStats.compressedRam),
                    ("Cached", ramStats.cachedRam),
                    ("Swap Used", ramStats.swapUsedRam),
                ]
            )
            .tabItem {
                Label("RAM", systemImage: "internaldrive")
            }
        }
    }
}
