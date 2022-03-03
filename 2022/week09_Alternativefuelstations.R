#Load Libraries
library(tidyverse)
library(systemfonts)
library(patchwork)
library(sf)
library(ggtext)

#Download and load shapefile
#https://github.com/rfordatascience/tidytuesday/blob/master/data/2022/2022-03-01/Alternative_Fueling_Stations.zip
shp <- st_read("Alternative_Fueling_Stations.shp")
us <- rgeoboundaries::gb_adm0("USA")

#Color palettes
pal1 <- c("#F8766D","#7CAE00","#00BFC4","#C77CFF")
pal2 <- c("#FFC107", "#00BA38", "#619CFF")

#plots
renew <- ggplot()+
  geom_sf(data=shp %>% filter(FUEL_TYPE_ %in% c("E85","ELEC","BD","HY")),
          mapping=aes(color=FUEL_TYPE_),
          size = 0.5, alpha = 0.5)+
  scale_color_manual(values=pal1)

nonrenew <- ggplot()+
  geom_sf(data=shp %>% filter(FUEL_TYPE_ %in% c("LPG","LNG","CNG")),
          mapping=aes(color=FUEL_TYPE_),
          size = 0.5, alpha = 0.5)+
  scale_color_manual(values=pal2)

#Patchwork
renew + nonrenew &
  geom_sf(data = us,fill="transparent",color="gray")&
  coord_sf(
    xlim = c(-124, -68),
    ylim = c(22, 50)
  ) &
  theme_minimal()+
  theme(legend.position = "none",
        axis.line = element_blank(),
        axis.text = element_blank(),
        panel.grid = element_blank()) &
  plot_annotation(title = "ALTERNATIVE doesn't always mean RENEWABLE!",
                  subtitle = "The maps below show the location of **renewable** (left) and **non-renewable** (right) alternative fuel stations across contiguous US.<br> Majority of fueling sources are renewable with <span style='color:#00BFC4'>electric stations</span> being the largest at <span style='color:#00BFC4'>83.70 % </span> followed by <span style='color:#7CAE00'>Ethanol (7.30 %) </span>,<span style='color:#F8766D'> Biodiesel (1.18 %) </span> and <span style='color:#C77CFF'> Hydrogen (0.2 %) </span>.<br> 
                              <span style='color:#619CFF'> Propane (LPG) </span>, <span style='color:#FFC107'> Compressed Natural Gas (CNG) </span> & <span style='color:#00BA38'>Liquefied Nitrogen Gas (LNG) </span> are non-renewable alternative sources that occupies <span style='color:#619CFF'> 4.73 </span>,<span style='color:#FFC107'> 2.57 </span>, and <span style='color:#00BA38'>0.25 </span> percentatges of alternative fueling stations in the US.",
                  caption = "Source: US DOT | Viz. Nischal Karki",
                  theme = theme(plot.background = element_rect(fill="#262833",
                                                               color="#262833"),
                                plot.title = element_markdown(family="Syne Mono",
                                                          color="White",
                                                          size= 35,
                                                          hjust = 0.5),
                                plot.subtitle = element_markdown(family="Lato",
                                                                 color="White",
                                                                 size=12,
                                                                 hjust=0.5),
                                plot.caption = element_text(family="Lato",
                                                           color="gray",
                                                           size=8)
                  ))

#save
ggsave('week09_AlternativeFuelStations.png',width=16,height=10)



