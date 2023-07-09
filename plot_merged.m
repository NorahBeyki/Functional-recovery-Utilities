clear all; close all
clc

crew = [10,30,50,60];
linetype = {'--','-.',':','-'};
linemarker = ["--^","-.square",":o","-*"];
color = [0.4660 0.6740 0.1880;0 0.4470 0.7410;0.8500 0.3250 0.0980;0.9290 0.6940 0.1250;0.4940 0.1840 0.5560];
model_name = 'Montecito Apartments Original'; % Name of the model;
model_dir = ['outputs' filesep model_name]; % Directory where the simulated inputs are located

reoccupancy_With_median   = zeros(4,7);
functional_With_median    = zeros(4,7);
reoccupancy_WO_median     = zeros(4,7);
functional_WO_median      = zeros(4,7);
PercentChange_reoccupancy = zeros(4,7);
PercentChange_functional  = zeros(4,7);
labels = {'72', '108' ,'224' ,'475' ,'975',  '2475' ,'4975'};
    X = categorical(labels);
    X = reordercats(X,labels);
for j=1:4
    result_dir = ['outputs' filesep model_name filesep strcat('Crew_',num2str(crew(j)))]; % Directory where the simulated inputs are located
    for i=1:7
        output_With = load([result_dir filesep strcat('recovery_outputs_intensity_',num2str(i),'.mat')]);
        reoccupancy_With_median(j,i) = median(output_With.functionality.recovery.reoccupancy.building_level.recovery_day);
        functional_With_median(j,i) = median(output_With.functionality.recovery.functional.building_level.recovery_day);

        output_WO = load([model_dir filesep strcat('recovery__Nolifeline_outputs_intensity_',num2str(i),'.mat')]);
        reoccupancy_WO_median(j,i) = median(output_WO.functionality.recovery.reoccupancy.building_level.recovery_day);
        functional_WO_median(j,i) = median(output_WO.functionality.recovery.functional.building_level.recovery_day);

    end
    PercentChange_reoccupancy(j,:) = ((reoccupancy_With_median(j,:)-reoccupancy_WO_median(j,:))./reoccupancy_WO_median(j,:))*100;
    PercentChange_functional(j,:)  = ((functional_With_median(j,:)-functional_WO_median(j,:))./functional_WO_median(j,:))*100;

    figure(1)
    set(gcf,'units','inches','position',[0.01   0.05   3.5   2.5],'color','w','PaperPositionMode','auto');  %Suitable for copying to word document (120% - 125%)
    set(gca,'Fontname','Arial','Fontsize',9,'FontWeight','normal');
    if j==1
        plot(X,reoccupancy_WO_median(j,:),'-diamond','DisplayName','w/o utilities','LineWidth',1,'MarkerFaceColor',color(1,:),'Color',color(1,:),'MarkerEdgeColor',color(1,:),'MarkerSize',4)
%         legend('Location',[0.450892857142857,0.144444444444444,0.447420634920635,0.288888888888889])
%         yticks(0:100:800)
    end
    hold on
    plot(X,reoccupancy_With_median(j,:),linemarker(1,j),'DisplayName',strcat('w utilities - crews=',num2str(crew(j))),'LineWidth',1,'MarkerFaceColor',color(j+1,:),'Color',color(j+1,:),'MarkerEdgeColor',color(j+1,:),'MarkerSize',4)
    box on; grid on
    xlabel({'Return Period (Years)'},'FontWeight','normal','Fontname','Arial','Fontsize',9)
    ylabel({'Median Number of Days'},'FontWeight','normal','Fontname','Arial','Fontsize',9)
    set(legend,'Fontname','Arial','Fontsize',8,'FontWeight','normal');
    legend('Location',[0.450892857142857,0.144444444444444,0.447420634920635,0.288888888888889]);
    ax = gca;
    ax.XAxis.FontSize = 9;
    ax.YAxis.FontSize = 9;
    saveas(gcf,[result_dir filesep 'Reocc_curve.jpeg'])
    hold on
    ylim([0 800])
    yticks(0:100:800)

    figure(2)
    set(gcf,'units','inches','position',[0.01   0.05   3.5   2.5],'color','w','PaperPositionMode','auto');  %Suitable for copying to word document (120% - 125%)
    set(gca,'Fontname','Arial','Fontsize',9,'FontWeight','normal');
    if j==1
        plot(X,functional_WO_median(j,:),'-diamond','DisplayName','w/o utilities','LineWidth',1,'MarkerFaceColor',color(1,:),'Color',color(1,:),'MarkerEdgeColor',color(1,:),'MarkerSize',4)
    end
    hold on
    plot(X,functional_With_median(j,:),linemarker(1,j),'DisplayName',strcat('w utilities - crews=',num2str(crew(j))),'LineWidth',1,'MarkerFaceColor',color(j+1,:),'Color',color(j+1,:),'MarkerEdgeColor',color(j+1,:),'MarkerSize',4)
    legend('Location',[0.450892857142857,0.144444444444444,0.447420634920635,0.288888888888889])
    box on; grid on
    xlabel({'Return Period (Years)'},'FontWeight','normal','Fontname','Arial','Fontsize',9)
    ylabel({'Median Number of Days'},'FontWeight','normal','Fontname','Arial','Fontsize',9)
    set(legend,'Fontname','Arial','Fontsize',8,'FontWeight','normal');
    ax = gca;
    ax.XAxis.FontSize = 9;
    ax.YAxis.FontSize = 9;
    saveas(gcf,[result_dir filesep 'func_curve.jpeg'])
    hold on
    ylim([0 800])
    yticks(0:100:800)

end
    color(1,:)=[];
    figure(3)
    set(gcf,'units','inches','position',[0.01   0.05   3.5   1.8],'color','w','PaperPositionMode','auto');  %Suitable for copying to word document (120% - 125%)
    set(gca,'Fontname','Arial','Fontsize',9,'FontWeight','normal');

        PercentChange_reoccupancy(1:3,:)=flip(PercentChange_reoccupancy(1:3,:));
    
    b = bar(X,PercentChange_reoccupancy',0.8);
    b(1).FaceColor = color(1,:);b(2).FaceColor = color(2,:);
    b(3).FaceColor = color(3,:);b(4).FaceColor = color(4,:);
    grid on
    ylim([0,5])
    legend('Crew=10','Crew=30','Crew=50','Crew=60','Location',[0.582341269841269,0.572081247232419,0.313988095238093,0.34073359073359])
    xlabel({'Return Period (Years)'},'FontWeight','normal','Fontname','Arial','Fontsize',9)
    ylabel({'% Change wrt w/o utilities'},'FontWeight','normal','Fontname','Arial','Fontsize',9)
    ax = gca;
    ax.XAxis.FontSize = 8;
    ax.YAxis.FontSize = 8;
    saveas(gcf,[result_dir filesep 'Reoc_column.jpeg'])
    
    figure(4)
    set(gcf,'units','inches','position',[0.01   0.05   3.5   1.8],'color','w','PaperPositionMode','auto');  %Suitable for copying to word document (120% - 125%)
    set(gca,'Fontname','Arial','Fontsize',9,'FontWeight','normal');
    bb = bar(X,PercentChange_functional',0.8);
    bb(1).FaceColor = color(1,:);bb(2).FaceColor = color(2,:);
    bb(3).FaceColor = color(3,:);bb(4).FaceColor = color(4,:);
    grid on
    ylim([0,200])
    legend('Crew=10','Crew=30','Crew=50','Crew=60','Location',[0.582341269841269,0.572081247232419,0.313988095238093,0.34073359073359])
    xlabel({'Return Period (Years)'},'FontWeight','normal','Fontname','Arial','Fontsize',9)
    ylabel({'% Change wrt w/o utilities'},'FontWeight','normal','Fontname','Arial','Fontsize',9)
    ax = gca;
    ax.XAxis.FontSize = 8;
    ax.YAxis.FontSize = 8;
    saveas(gcf,[result_dir filesep 'func_column.jpeg'])






















